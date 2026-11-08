import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/auction/widgets/tab_bar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_product_detail_model.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/controllers/wholesale_product_details_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/productDetails/widgets/wholesale_product_details_section_widget.dart';
import 'package:sixvalley_vendor_app/helper/product_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleProductAttributeImagesWidget extends StatelessWidget {
  const WholesaleProductAttributeImagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleProductDetailsController>(
      builder: (context, controller, _) {
        final List<String> types = controller.attributeTypes;
        if (types.isEmpty) return const SizedBox();

        final Map<String, List<WholesaleAttributeImage>> grouped = controller.imagesBySelectedAttributeValue;

        return WholesaleProductDetailsSectionWidget(
          title: getTranslated('attribute_wise_image', context) ?? 'Attribute wise Image',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBarWidget(
                  selectedIndex: controller.selectedAttributeTypeIndex.clamp(0, types.length - 1),
                  tabs: types.map((type) => ProductHelper.capitalizeFirstLetter(type)).toList(),
                  onTabChanged: controller.onChangeAttributeType,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeMedium),

              for (final MapEntry<String, List<WholesaleAttributeImage>> entry in grouped.entries) ...[
                Text(
                  entry.key,
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Wrap(
                  spacing: Dimensions.paddingSizeSmall,
                  runSpacing: Dimensions.paddingSizeSmall,
                  children: [
                    for (final WholesaleAttributeImage image in entry.value)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImageWidget(
                          image: image.imageFullUrl?.path ?? '',
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeMedium),
              ],
            ],
          ),
        );
      },
    );
  }
}
