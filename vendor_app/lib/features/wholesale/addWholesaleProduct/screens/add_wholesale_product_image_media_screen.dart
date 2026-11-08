import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_additional_images_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_bottom_nav_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_thumbnail_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_variation_image_upload_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/widgets/add_wholesale_product_video_widget.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';

class AddWholesaleProductImageMediaScreen extends StatefulWidget {
  final Function(int) onTabChanged;
  const AddWholesaleProductImageMediaScreen({super.key, required this.onTabChanged});

  @override
  State<AddWholesaleProductImageMediaScreen> createState() => AddWholesaleProductImageMediaScreenState();
}

class AddWholesaleProductImageMediaScreenState extends State<AddWholesaleProductImageMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                AddProductSectionWidget(
                  title: getTranslated('upload_thumbnail', context)!,
                  subTitle: getTranslated('product_additional_image_info', context)!,
                  isRequired: true,
                  childrenPadding: Dimensions.paddingSizeMedium,
                  childrens: const [
                    SizedBox(height: Dimensions.paddingSizeDefault),
                    AddWholesaleProductThumbnailWidget(),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
                SizedBox(height: Dimensions.paddingSizeLarge),

                AddProductSectionWidget(
                  title: getTranslated('product_additional_images', context)!,
                  subTitle: getTranslated('product_additional_image_info', context)!,
                  childrenPadding: Dimensions.paddingSizeMedium,
                  childrens: const [
                    SizedBox(height: Dimensions.paddingSizeDefault),
                    AddWholesaleProductAdditionalImagesWidget(),
                    SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
                SizedBox(height: Dimensions.paddingSizeLarge),

                const AddWholesaleProductVariationImageUploadWidget(),
                SizedBox(height: Dimensions.paddingSizeLarge),

                const AddWholesaleProductVideoWidget(),
              ],
            ),
          ),
        ),
        AddWholesaleProductBottomNavWidget(
          onGoBack: () => widget.onTabChanged(1),
          actionLabel: getTranslated('next', context) ?? 'Next',
          onAction: () => widget.onTabChanged(3),
        ),
      ],
    );
  }
}
