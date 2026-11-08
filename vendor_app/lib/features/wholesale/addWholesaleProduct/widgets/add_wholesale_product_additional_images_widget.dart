import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/domain/models/wholesale_gallery_image_model.dart';
import 'package:sixvalley_vendor_app/helper/image_size_checker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductAdditionalImagesWidget extends StatelessWidget {
  const AddWholesaleProductAdditionalImagesWidget({super.key});

  static const double _emptyBoxSize = 130;

  Future<void> _pickAdditionalImage(BuildContext context, AddWholesaleProductController controller) async {
    final List<XFile> pickedImages = await ImageValidationHelper.validateAndPickMultipleImages(context: context);
    if (pickedImages.isNotEmpty) {
      controller.addAdditionalImages(pickedImages);
    }
  }

  Widget _addTile(BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [4, 5],
          color: Theme.of(context).hintColor,
          radius: const Radius.circular(Dimensions.radiusDefault),
        ),
        child: SizedBox.expand(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAssetImageWidget(Images.addImageIcon, height: 30, width: 30, color: Theme.of(context).hintColor.withValues(alpha: .7)),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(getTranslated('click_to_add', context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: .7))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        final List<WholesaleGalleryImage> images = controller.galleryImages;

        if (images.isEmpty) {
          return SizedBox(
            width: _emptyBoxSize,
            height: _emptyBoxSize,
            child: _addTile(context, () => _pickAdditionalImage(context, controller)),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 2,
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length + 1,
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _addTile(context, () => _pickAdditionalImage(context, controller));
            }

            final WholesaleGalleryImage image = images[index];

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: const [4, 5],
                      color: Theme.of(context).hintColor,
                      radius: const Radius.circular(Dimensions.radiusDefault),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: image.file != null
                          ? Image.file(File(image.file!.path), width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                          : CustomImageWidget(image: image.storedUrl ?? '', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                    ),
                  ),
                ),

                Positioned(
                  top: -Dimensions.paddingSizeExtraSmall,
                  right: -Dimensions.paddingSizeExtraSmall,
                  child: InkWell(
                    onTap: () => controller.removeGalleryImage(images[index]),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.error),
                      child: Icon(Icons.delete, size: Dimensions.iconSizeSmall, color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
