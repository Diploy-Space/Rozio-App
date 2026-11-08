import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductStockSetupWidget extends StatefulWidget {
  const AddWholesaleProductStockSetupWidget({super.key});

  @override
  State<AddWholesaleProductStockSetupWidget> createState() => _AddWholesaleProductStockSetupWidgetState();
}

class _AddWholesaleProductStockSetupWidgetState extends State<AddWholesaleProductStockSetupWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AddWholesaleProductController, VariationController>(
      builder: (context, controller, variationController, _) {
        final bool hasVariation = controller.isAttributeActive && variationController.variantTypeList.isNotEmpty;

        return AddProductSectionWidget(
          title: getTranslated('stock_setup', context)!,
          subTitle: getTranslated('here_you_can_setup_the_price', context)!,
          childrenPadding: 0,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),
            if (!hasVariation)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimensions.paddingSizeDefault,
                  left: Dimensions.paddingSizeSmall,
                  right: Dimensions.paddingSizeSmall
                ),

                child: CustomTextFieldWidget(
                  border: true,
                  controller: controller.totalQuantityController,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                  isAmount: true,
                  hintText: getTranslated('quantity', context)!,
                  formProduct: true,
                  suffixIconImage: null,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                itemCount: variationController.variantTypeList.length,
                separatorBuilder: (context, index) => const SizedBox(height: Dimensions.paddingSizeLarge),
                itemBuilder: (context, index) {
                  final variant = variationController.variantTypeList[index];
                  return Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: index.isEven ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : null,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          variant.variantType.split('-').join(' - '),
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFieldWidget(
                                border: true,
                                controller: controller.variantSkuController(variant.variantType),
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.text,
                                hintText: getTranslated('sku', context)!,
                                formProduct: true,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: CustomTextFieldWidget(
                                border: true,
                                controller: variant.qtyController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                                isAmount: true,
                                hintText: getTranslated('quantity', context)!,
                                formProduct: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
