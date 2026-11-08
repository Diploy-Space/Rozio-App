import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/wholesale/ai/widgets/wholesale_ai_image_analyze_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class WholesaleAiGeneratorBottomSheet extends StatelessWidget {
  final ValueChanged<String> onImageNameGenerated;

  const WholesaleAiGeneratorBottomSheet({super.key, required this.onImageNameGenerated});

  void _openImageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (BuildContext sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: WholesaleAiImageAnalyzeBottomSheet(onNameGenerated: onImageNameGenerated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        CustomAssetImageWidget(Images.aiAssistance, height: 70, width: 70),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          getTranslated('hi_there', context) ?? '',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.headlineLarge?.color),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text(
          getTranslated('i_am_here_to_help_you', context) ?? '',
          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text(
            getTranslated('ai_assistance_description', context) ?? '',
            style: robotoRegular.copyWith(color: Theme.of(context).textTheme.headlineLarge?.color),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: CustomButtonWidget(
            btnTxt: getTranslated('upload_image', context) ?? '',
            backgroundColor: Theme.of(context).primaryColor,
            onTap: () => _openImageSheet(context),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text(
            getTranslated('ai_may_make_mistakes', context) ?? '',
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.headlineLarge?.color),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}
