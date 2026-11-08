import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attribute_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/quantity_price_tier_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductVariationPriceSetupWidget extends StatefulWidget {
  const AddWholesaleProductVariationPriceSetupWidget({super.key});

  @override
  State<AddWholesaleProductVariationPriceSetupWidget> createState() => _AddWholesaleProductVariationPriceSetupWidgetState();
}

class _AddWholesaleProductVariationPriceSetupWidgetState extends State<AddWholesaleProductVariationPriceSetupWidget> {
  bool _isExpanded = true;

  String _tierRangeLabel(QuantityPriceTierModel tier) {
    final String min = tier.minQtyController.text.trim();
    final String max = tier.maxQtyController.text.trim();
    if (max.isEmpty) {
      return '(≥$min)';
    }
    return '($min-$max)';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddWholesaleProductController, VariationController>(
      builder: (context, controller, variationController, _) {
        AttributeModel? selectedAttribute;
        for (AttributeModel attribute in variationController.attributeList ?? []) {
          if (attribute.attribute.id == controller.selectedVariationTypeAttrId) {
            selectedAttribute = attribute;
            break;
          }
        }

        final List<String> variants = selectedAttribute?.variants.whereType<String>().toList() ?? [];

        if (selectedAttribute == null || variants.isEmpty) {
          return const SizedBox();
        }

        final bool showQuantityCombos = controller.isQuantityBasePricing;
        final List<QuantityPriceTierModel> tiers = controller.quantityPriceTiers;

        final List<Widget> cards = [];
        if (showQuantityCombos) {
          for (String variant in variants) {
            for (int tierIndex = 0; tierIndex < tiers.length; tierIndex++) {
              cards.add(_VariationPriceCardWidget(
                title: Text(
                  '${selectedAttribute.attribute.name} $variant ${_tierRangeLabel(tiers[tierIndex])}',
                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                priceController: controller.variationTierPriceController(variant, tierIndex),
                discountController: controller.variationTierDiscountController(variant, tierIndex),
              ));
            }
          }
        } else {
          for (String variant in variants) {
            cards.add(_VariationPriceCardWidget(
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${selectedAttribute.attribute.name}: ',
                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
                    ),
                    TextSpan(
                      text: variant,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ],
                ),
              ),
              priceController: controller.variationPriceController(variant),
              discountController: controller.variationDiscountController(variant),
            ));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: Dimensions.paddingSizeMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated('variation_base_price_setup', context)!,
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_up),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: !_isExpanded
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, Dimensions.paddingSizeDefault),
                      child: Column(children: cards),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _VariationPriceCardWidget extends StatelessWidget {
  final Widget title;
  final TextEditingController priceController;
  final TextEditingController discountController;

  const _VariationPriceCardWidget({required this.title, required this.priceController, required this.discountController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeMedium),
      padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Row(
            children: [
              Expanded(
                child: CustomTextFieldWidget(
                  border: true,
                  isAmount: true,
                  hintText: getTranslated('price', context),
                  hintStyle: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
                  controller: priceController,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: CustomTextFieldWidget(
                  border: true,
                  isAmount: true,
                  hintText: '${getTranslated('discount', context)} (%)',
                  hintStyle: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
                  controller: discountController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
