import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/addProduct/widgets/add_product_section_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/addWholesaleProduct/controllers/add_wholesale_product_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AddWholesaleProductVideoWidget extends StatelessWidget {
  const AddWholesaleProductVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddWholesaleProductController>(
      builder: (context, controller, _) {
        return AddProductSectionWidget(
          title: getTranslated('product_video', context)!,
          subTitle: getTranslated('wholesale_product_video_description', context)!,
          childrenPadding: Dimensions.paddingSizeMedium,
          childrens: [
            const SizedBox(height: Dimensions.paddingSizeDefault),

            RadioGroup<VideoUploadType>(
              groupValue: controller.videoUploadType,
              onChanged: (type) => controller.setVideoUploadType(type ?? controller.videoUploadType),
              child: Row(
                children: [
                  Expanded(
                    child: _VideoTypeRadioWidget(
                      label: getTranslated('upload_video_link', context)!,
                      value: VideoUploadType.link,
                      isSelected: controller.videoUploadType == VideoUploadType.link,
                      onTap: controller.setVideoUploadType,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(
                    child: _VideoTypeRadioWidget(
                      label: getTranslated('upload_video_file', context)!,
                      value: VideoUploadType.file,
                      isSelected: controller.videoUploadType == VideoUploadType.file,
                      onTap: controller.setVideoUploadType,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeMedium),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: controller.videoUploadType == VideoUploadType.link
                  ? CustomTextFieldWidget(
                      key: const ValueKey('video-link'),
                      controller: controller.videoLinkController,
                      hintText: 'Ex : https://www.youtube.com/embed/...',
                      textInputType: TextInputType.url,
                      border: true
                    )
                  : _VideoFileSectionWidget(key: const ValueKey('video-file'), controller: controller),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ],
        );
      },
    );
  }
}

class _VideoTypeRadioWidget extends StatelessWidget {
  final String label;
  final VideoUploadType value;
  final bool isSelected;
  final ValueChanged<VideoUploadType> onTap;

  const _VideoTypeRadioWidget({required this.label, required this.value, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<VideoUploadType>(
            value: value,
            activeColor: Theme.of(context).primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
          Flexible(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: (isSelected ? robotoBold : robotoMedium).copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoFileSectionWidget extends StatelessWidget {
  final AddWholesaleProductController controller;

  const _VideoFileSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isPickingVideo) {
      return const SizedBox(
        width: 160,
        height: 130,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (controller.pickedVideoFile != null || controller.existingVideoUrl != null) {
      final String? path = controller.pickedVideoFile != null ? controller.pickedVideoFile!.thumbnailPath : controller.existingVideoThumbnailPath;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 160,
            height: 130,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (path != null && path.isNotEmpty)
                  Image.file(File(path), fit: BoxFit.cover)
                else
                  Icon(Icons.video_file_rounded, size: 48, color: Theme.of(context).hintColor),
                Center(
                  child: Icon(Icons.play_circle_fill_rounded, size: 36, color: Theme.of(context).cardColor.withValues(alpha: .9)),
                ),
              ],
            ),
          ),
          Positioned(
            top: -Dimensions.paddingSizeExtraSmall,
            right: -Dimensions.paddingSizeExtraSmall,
            child: InkWell(
              onTap: () => controller.removeVideoFile(),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.error),
                child: Icon(Icons.delete, size: Dimensions.iconSizeSmall, color: Theme.of(context).cardColor),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => controller.pickVideoFile(context),
      child: Container(
        width: 160,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).hintColor),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_fill_rounded, size: 36, color: Theme.of(context).hintColor.withValues(alpha: .7)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(getTranslated('click_to_add', context)!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor.withValues(alpha: .7))),
            ],
          ),
        ),
      ),
    );
  }
}
