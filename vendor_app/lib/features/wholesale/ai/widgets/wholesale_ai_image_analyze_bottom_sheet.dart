import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/controllers/wholesale_ai_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleAiImageAnalyzeBottomSheet extends StatefulWidget {
  final ValueChanged<String> onNameGenerated;

  const WholesaleAiImageAnalyzeBottomSheet({super.key, required this.onNameGenerated});

  @override
  State<WholesaleAiImageAnalyzeBottomSheet> createState() => _WholesaleAiImageAnalyzeBottomSheetState();
}

class _WholesaleAiImageAnalyzeBottomSheetState extends State<WholesaleAiImageAnalyzeBottomSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<WholesaleAiController>(context, listen: false).removeImage(willUpdate: false);
  }

  Future<void> _analyze(WholesaleAiController aiController) async {
    if (aiController.pickedImage == null) {
      showCustomSnackBarWidget(getTranslated('please_upload_an_image', context), context);
      return;
    }

    final NavigatorState navigator = Navigator.of(context);
    final String? name = await aiController.analyzeImage();

    if (!mounted) {
      return;
    }

    navigator
      ..pop()
      ..pop();

    if (name != null) {
      widget.onNameGenerated(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleAiController>(
      builder: (context, aiController, _) {
        return PopScope(
          canPop: !aiController.imageLoading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Container(
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
                  child: InkWell(
                    onTap: aiController.imageLoading ? null : () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, color: Theme.of(context).hintColor.withValues(alpha: 0.6), size: 22),
                  ),
                ),
              ]),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('upload_image', context) ?? '',
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    getTranslated('please_give_proper_image_to_generate_full_data_for_your_food', context) ?? '',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  _TipWidget(text: getTranslated('try_to_use_a_clean_and_avoid_blur_image', context) ?? ''),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  _TipWidget(text: getTranslated('use_as_close_as_your_product_image', context) ?? ''),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: aiController.imageLoading ? null : aiController.pickImage,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 1,
                            dashPattern: const [5, 5],
                            padding: EdgeInsets.zero,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: aiController.pickedImage != null
                                  ? Image.file(
                                      File(aiController.pickedImage!.path),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.broken_image_outlined,
                                        size: 38,
                                        color: Theme.of(context).hintColor.withValues(alpha: 0.5),
                                      ),
                                    )
                                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Icon(CupertinoIcons.camera_fill, size: 38, color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                      Text(
                                        getTranslated('upload_image', context) ?? '',
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                                      ),
                                    ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  if (aiController.imageLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: Shimmer.fromColors(
                          baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18),
                          highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.06),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.auto_awesome, color: Colors.blue),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(getTranslated('generating', context) ?? '', style: robotoBold.copyWith(color: Colors.blue)),
                          ]),
                        ),
                      ),
                    )
                  else
                    CustomButtonWidget(
                      btnTxt: getTranslated('analyze_and_generate_content', context) ?? '',
                      backgroundColor: Theme.of(context).primaryColor,
                      onTap: () => _analyze(aiController),
                    ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class _TipWidget extends StatelessWidget {
  final String text;
  const _TipWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(backgroundColor: Theme.of(context).hintColor, radius: 3),
      const SizedBox(width: Dimensions.paddingSizeSmall),
      Expanded(
        child: Text(
          text,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
        ),
      ),
    ]);
  }
}
