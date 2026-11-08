import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/discount_text_field_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/domain/models/wholesale_ai_pricing_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/enums/wholesale_ai_image_step.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_sparkle_widget.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/controllers/wholesale_vat_tax_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/vatTax/domain/models/wholesale_vat_tax_setup_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_quantity_price_setup_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_variation_price_setup_widget.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductPricingSetupWidget extends StatefulWidget {
  const AddWholesaleProductPricingSetupWidget({super.key});

  @override
  State<AddWholesaleProductPricingSetupWidget> createState() => _AddWholesaleProductPricingSetupWidgetState();
}

class _AddWholesaleProductPricingSetupWidgetState extends State<AddWholesaleProductPricingSetupWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);
      if (aiController.consumeImageStep(WholesaleAiImageStep.pricing)) {
        _generatePricingSetup(
          context,
          Provider.of<AddWholesaleProductController>(context, listen: false),
          languageIndex: aiController.imageLanguageIndex,
        );
      }
    });
  }

  Future<void> _generatePricingSetup(BuildContext context, AddWholesaleProductController controller, {int languageIndex = 0}) async {
    if (controller.titleControllerList.isEmpty || controller.descriptionControllerList.isEmpty) {
      return;
    }

    final int index = languageIndex < controller.titleControllerList.length && languageIndex < controller.descriptionControllerList.length ? languageIndex : 0;
    final String name = controller.titleControllerList[index].text.trim();
    final String description = controller.descriptionControllerList[index].text.trim();

    if (name.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_name_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }
    if (description.isEmpty) {
      showCustomSnackBarWidget(getTranslated('product_description_required', context), context, sanckBarType: SnackBarType.warning);
      return;
    }

    final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context, listen: false);

    await aiController.generatePricingSetup(
      name: name,
      description: description,
      apply: (WholesaleAiPricingSetupModel pricing) async {
        if (!context.mounted) {
          return;
        }

        await controller.applyAiPricingSetup(context, pricing);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        final WholesaleAiController aiController = Provider.of<WholesaleAiController>(context);

        return AddProductSectionWidget(
          title: getTranslated('pricing_setup', context)!,
          subTitle: getTranslated('here_you_can_setup_the_price', context)!,
          isAiGenerating: aiController.pricingSetupLoading,
          aiWidget: Provider.of<SplashController>(context, listen: false).configModel?.isAiFeatureActive == 1
              ? WholesaleAiSparkleWidget(isLoading: aiController.pricingSetupLoading, onTap: () => _generatePricingSetup(context, controller)) : null,
          childrenPadding: Dimensions.paddingSize,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Container(
              padding: EdgeInsets.only(
                left: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(Dimensions.paddingEye),
              ),
              child: Column(
                children: [
                  if (!controller.isVariationBasePricing) ...[
                    ProductDiscountTextFieldWidget(
                      formProduct: true,
                      border: true,
                      borderColor: Theme.of(context).primaryColor.withValues(alpha: .25),
                      controller: controller.discountController,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      isAmount: true,
                      hintText: getTranslated('discount', context)!,
                      isDiscountAmount: controller.isDiscountAmount,
                      onDiscountTypeChanged: (String? value) => controller.setIsDiscountAmount(value == 'amount'),
                    ),
                    const SizedBox(height: Dimensions.paddingSize),
                  ],

                  Consumer<WholesaleVatTaxController>(
                    builder: (context, vatTaxController, _) {
                      if (!vatTaxController.isTaxSelectable) {
                        return const SizedBox();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownDecoratorWidget(
                            child: DropdownButton<WholesaleTaxModel>(
                              icon: const Icon(Icons.keyboard_arrow_down_outlined),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
                              hint: Text('${getTranslated('vat_tax_rate', context)} *', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                              items: vatTaxController.taxList.map((WholesaleTaxModel value) {
                                final bool isSelected = vatTaxController.isSelected(value);
                                return DropdownMenuItem<WholesaleTaxModel>(
                                  enabled: !isSelected,
                                  value: value,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${value.name} ${value.id != 0 ? '(${value.taxRate}%)' : ''}'),
                                      if (isSelected) Icon(Icons.check, color: Theme.of(context).primaryColor, size: 18),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (WholesaleTaxModel? value) {
                                if (value == null) {
                                  return;
                                }

                                if (value.id == 0) {
                                  vatTaxController.selectAllTaxes();
                                } else {
                                  vatTaxController.addToSelectedTaxList(value);
                                }
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                          if (vatTaxController.selectedTaxList.isNotEmpty) ...[
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                itemCount: vatTaxController.selectedTaxList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final WholesaleTaxModel tax = vatTaxController.selectedTaxList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium),
                                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withValues(alpha: .20),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${tax.name} (${tax.taxRate}%)',
                                            style: robotoRegular.copyWith(color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7)),
                                          ),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            onTap: () => vatTaxController.removeFromSelectedTaxList(index),
                                            child: Icon(Icons.close, size: 15, color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.7)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: Dimensions.paddingSizeVeryTiny),
                        ],
                      );
                    },
                  ),

                  DropdownDecoratorWidget(
                    title: 'price_setup',
                    isRequired: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.setIsVariationBasePricing(!controller.isVariationBasePricing),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: controller.isVariationBasePricing,
                                    activeColor: Theme.of(context).primaryColor,
                                    checkColor: Theme.of(context).cardColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) => controller.setIsVariationBasePricing(value ?? false),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Flexible(
                                    child: Text(
                                      getTranslated('variation_base', context)!,
                                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.setIsQuantityBasePricing(!controller.isQuantityBasePricing),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: controller.isQuantityBasePricing,
                                    activeColor: Theme.of(context).primaryColor,
                                    checkColor: Theme.of(context).cardColor,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    onChanged: (value) => controller.setIsQuantityBasePricing(value ?? false),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Flexible(
                                    child: Text(
                                      getTranslated('quantity_base', context)!,
                                      style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSize),

                  CustomTextFieldWidget(
                    border: true,
                    controller: controller.minimumOrderQuantityController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.number,
                    isAmount: true,
                    hintText: getTranslated('minimum_order_quantity', context)!,
                    formProduct: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSize),

                  if (controller.isVariationBasePricing)
                    Consumer<VariationController>(
                      builder: (context, variationController, _) {
                        final activeAttributes = controller.variationTypeAttributes(variationController);
                        final bool isSelectionListed = activeAttributes
                            .any((attribute) => attribute.attribute.id == controller.selectedVariationTypeAttrId);

                        return DropdownDecoratorWidget(
                          child: DropdownButton<int>(
                            icon: const Icon(Icons.keyboard_arrow_down_outlined),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
                            hint: Text(getTranslated('select_variation_type', context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                            value: isSelectionListed ? controller.selectedVariationTypeAttrId : null,
                            items: activeAttributes.map((attribute) {
                              return DropdownMenuItem<int>(
                                value: attribute.attribute.id,
                                child: Text(attribute.attribute.name ?? '', style: robotoMedium),
                              );
                            }).toList(),
                            onChanged: (int? value) => controller.setSelectedVariationTypeAttrId(value),
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        );
                      },
                    ),

                ],
              ),
            ),

            if (controller.isQuantityBasePricing) ...[
              const SizedBox(height: Dimensions.paddingSizeLarge),
              const AddWholesaleProductQuantityPriceSetupWidget(),
            ],

            if (controller.isVariationBasePricing && controller.selectedVariationTypeAttrId != null) ...[
              const SizedBox(height: Dimensions.paddingSizeLarge),
              const AddWholesaleProductVariationPriceSetupWidget(),
            ],
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}
