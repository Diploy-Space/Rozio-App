import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AppModeWelcomeBottomSheet extends StatelessWidget {
  final AppMode appMode;

  const AppModeWelcomeBottomSheet({super.key, required this.appMode});

  @override
  Widget build(BuildContext context) {
    final String moduleName = getTranslated(appMode.titleKey, context) ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).cardColor,
                    child: Icon(Icons.close,
                      size: Dimensions.iconSizeDefault,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                getTranslated('module_welcome_title', context) ?? '',
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLargeTwenty,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeMedium),
              Text(
                getTranslated('module_welcome_description', context)?.replaceAll('{module}', moduleName) ?? '',
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  height: 1.6,
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.4,
                child: CustomButtonWidget(
                  btnTxt: getTranslated('got_it', context),
                  textSize: Dimensions.fontSizeLarge,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        ),
      ),
    );
  }
}
