import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/quantity_price_tier_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductQuantityPriceSetupWidget extends StatefulWidget {
  const AddWholesaleProductQuantityPriceSetupWidget({super.key});

  @override
  State<AddWholesaleProductQuantityPriceSetupWidget> createState() => _AddWholesaleProductQuantityPriceSetupWidgetState();
}

class _AddWholesaleProductQuantityPriceSetupWidgetState extends State<AddWholesaleProductQuantityPriceSetupWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        final tiers = controller.quantityPriceTiers;

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated('quantity_base_price_setup', context)!,
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
                        child: Column(
                          children: [
                            ...List.generate(tiers.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeMedium),
                                child: _QuantityPriceTierCardWidget(
                                  tier: tiers[index],
                                  showUnitPrice: !controller.isVariationBasePricing,

                                  isLastTier: index == tiers.length - 1,
                                  onRemove: (index == tiers.length - 1 && tiers.length > 1) ? () => controller.removeQuantityPriceTier(index) : null,
                                  onRangeChanged: controller.isVariationBasePricing ? controller.refreshQuantityPriceTiers : null,
                                ),
                              );
                            }),

                            InkWell(
                              onTap: () => controller.addQuantityPriceTier(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle, size: Dimensions.iconSizeDefault, color: Theme.of(context).primaryColor),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      getTranslated('add_tier', context)!,
                                      style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuantityPriceTierCardWidget extends StatelessWidget {
  final QuantityPriceTierModel tier;
  final bool showUnitPrice;
  final bool isLastTier;
  final VoidCallback? onRemove;
  final VoidCallback? onRangeChanged;

  const _QuantityPriceTierCardWidget({required this.tier, this.showUnitPrice = true, this.isLastTier = false, this.onRemove, this.onRangeChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TierFieldWidget(
                label: getTranslated('minimum_order_qty', context)!,
                controller: tier.minQtyController,
                onChanged: onRangeChanged,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              _TierFieldWidget(
                label: isLastTier
                    ? '${getTranslated('maximum_order_qty', context)!} (${getTranslated('and_above_if_empty', context)!})'
                    : getTranslated('maximum_order_qty', context)!,
                controller: tier.maxQtyController,
                onChanged: onRangeChanged,
              ),
              if (showUnitPrice) ...[
                const SizedBox(height: Dimensions.paddingSizeSmall),
                _TierFieldWidget(
                  label: getTranslated('unit_price_with_currency', context)!,
                  controller: tier.unitPriceController,
                ),
              ],
            ],
          ),
        ),

        if (onRemove != null)
          Positioned(
            top: -Dimensions.paddingSizeExtraSmall,
            right: -Dimensions.paddingSizeExtraSmall,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.error),
                child: Icon(Icons.close, size: Dimensions.iconSizeSmall, color: Theme.of(context).cardColor),
              ),
            ),
          ),
      ],
    );
  }
}

class _TierFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const _TierFieldWidget({required this.label, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      border: true,
      isAmount: true,
      formProduct: true,
      hintText: label,
      hintStyle: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
      controller: controller,
      onChanged: onChanged != null ? (_) => onChanged!() : null,
    );
  }
}
