import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/variation_controller.dart';
import 'package:sixvalley_vendor_app/features/addProduct/domain/models/attribute_model.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_variation_image_value_card_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductVariationImageUploadWidget extends StatefulWidget {
  const AddWholesaleProductVariationImageUploadWidget({super.key});

  @override
  State<AddWholesaleProductVariationImageUploadWidget> createState() => _AddWholesaleProductVariationImageUploadWidgetState();
}

class _AddWholesaleProductVariationImageUploadWidgetState extends State<AddWholesaleProductVariationImageUploadWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddWholesaleProductController, VariationController>(
      builder: (context, controller, variationController, _) {
        final List<AttributeModel> activeAttributes = (variationController.attributeList ?? []).where((attribute) => attribute.active).toList();

        if (activeAttributes.isEmpty) {
          return const SizedBox();
        }

        final bool hasValidSelection = activeAttributes.any((attribute) => attribute.attribute.id == controller.selectedImageAttributeId);
        if (!hasValidSelection) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final int? defaultId = controller.selectedVariationTypeAttrId ?? activeAttributes.first.attribute.id;
            controller.setSelectedImageAttributeId(defaultId);
          });
        }

        AttributeModel? selectedAttribute;
        for (AttributeModel attribute in activeAttributes) {
          if (attribute.attribute.id == controller.selectedImageAttributeId) {
            selectedAttribute = attribute;
            break;
          }
        }

        final List<String> values = selectedAttribute?.variants.whereType<String>().toList() ?? [];

        return AddProductSectionWidget(
          title: getTranslated('select_attribute_for_upload_product_images', context)!,
          subTitle: getTranslated('upload_images_based_on_specific_attribute_types', context)!,
          childrenPadding: Dimensions.paddingSizeMedium,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            DropdownDecoratorWidget(
              title: 'select_attribute_label',
              child: DropdownButton<int>(
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingEye)),
                hint: Text(getTranslated('select_attribute_label', context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                value: controller.selectedImageAttributeId,
                items: activeAttributes.map((attribute) {
                  return DropdownMenuItem<int>(
                    value: attribute.attribute.id,
                    child: Text(attribute.attribute.name ?? '', style: robotoMedium),
                  );
                }).toList(),
                onChanged: (int? value) => controller.setSelectedImageAttributeId(value),
                isExpanded: true,
                underline: const SizedBox(),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated('upload_image', context)!,
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

            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: !_isExpanded
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${getTranslated('upload_image_for_this_attribute', context)!} ',
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                              ),
                              TextSpan(
                                text: getTranslated('jpg_jpeg_png_image_size_max_2mb', context)!,
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡', style: TextStyle(fontSize: Dimensions.fontSizeLarge)),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Text(
                                  getTranslated('variation_image_additional_info', context)!,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: activeAttributes.map((attribute) {
                              final bool isSelected = attribute.attribute.id == controller.selectedImageAttributeId;

                              return Padding(
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                  onTap: () => controller.setSelectedImageAttributeId(attribute.attribute.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMedium, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                    ),
                                    child: Text(
                                      attribute.attribute.name ?? '',
                                      style: robotoMedium.copyWith(color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        if (selectedAttribute != null)
                          ...values.map((value) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeMedium),
                              child: AddWholesaleProductVariationImageValueCardWidget(
                                attributeId: selectedAttribute!.attribute.id!,
                                value: value,
                              ),
                            );
                          }),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
