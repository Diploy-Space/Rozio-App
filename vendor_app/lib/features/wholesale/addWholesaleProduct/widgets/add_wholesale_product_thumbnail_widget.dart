import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/helper/image_size_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductThumbnailWidget extends StatelessWidget {
  const AddWholesaleProductThumbnailWidget({super.key});

  static const double _size = 130;

  Future<void> _pickThumbnail(BuildContext context, AddWholesaleProductController controller) async {
    final XFile? pickedImage = await ImageValidationHelper.validateAndPickImage(context: context, source: ImageSource.gallery);
    if (pickedImage != null) {
      controller.setThumbnailImage(pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        final XFile? pickedImage = controller.thumbnailImage;

        final String? storedImage = controller.existingThumbnailUrl;
        final bool hasImage = pickedImage != null || (storedImage?.isNotEmpty ?? false);

        return SizedBox(
          width: _size,
          height: _size,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: const [4, 5],
              color: Theme.of(context).hintColor,
              radius: const Radius.circular(Dimensions.radiusDefault),
            ),
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      child: pickedImage != null
                          ? Image.file(File(pickedImage.path), width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                          : hasImage
                              ? CustomImageWidget(image: storedImage ?? '', width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                              : const SizedBox.shrink(),
                    ),
                  ),

                  Positioned.fill(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => _pickThumbnail(context, controller),
                      child: !hasImage
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomAssetImageWidget(Images.addImageIcon, height: 30, width: 30, color: Theme.of(context).hintColor.withValues(alpha: .7)),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Text(getTranslated('click_to_add', context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: .7))),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  if (hasImage)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: InkWell(
                          onTap: () => _pickThumbnail(context, controller),
                          child: const CustomAssetImageWidget(Images.editImageIcon, height: 25, width: 25),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
