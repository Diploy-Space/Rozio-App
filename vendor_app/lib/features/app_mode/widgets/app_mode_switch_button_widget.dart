import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_asset_image_widget.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_tutorial.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/app_mode/widgets/shopping_mode_bottom_sheet.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class AppModeSwitchButtonWidget extends StatelessWidget {
  const AppModeSwitchButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppModeAvailability.canSwitchMode(context)) {
      return const SizedBox.shrink();
    }

    final Widget chip = Consumer<AppModeController>(
      builder: (context, appModeController, _) {
        final appMode = appModeController.appMode;

        return InkWell(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ShoppingModeBottomSheet(),
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeOrder),
                  child: CustomAssetImageWidget(appMode.icon,
                    height: Dimensions.iconSizeDefault - 1, width: Dimensions.iconSizeDefault - 1),
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  getTranslated(appMode.titleKey, context) ?? '',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),
                Icon(Icons.keyboard_arrow_down_rounded,
                  size: Dimensions.iconSizeSmall,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
        );
      },
    );

    if (!AppModeTutorial.isRegistered) {
      return chip;
    }

    return Showcase(
      key: AppModeTutorial.switchButtonKey,
      scope: AppModeTutorial.scope,
      title: getTranslated('switch_module_tutorial_title', context),
      description: getTranslated('switch_module_tutorial_description', context),
      titleTextStyle: robotoBold.copyWith(
        fontSize: Dimensions.fontSizeDefault,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      descTextStyle: robotoRegular.copyWith(
        fontSize: Dimensions.fontSizeSmall,
        color: Theme.of(context).textTheme.headlineLarge?.color,
      ),
      tooltipBackgroundColor: Theme.of(context).cardColor,
      tooltipBorderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      tooltipPadding: const EdgeInsets.all(Dimensions.paddingSizeMedium),
      overlayColor: const Color(0xFF000000),
      overlayOpacity: 0.5,
      targetBorderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
      targetPadding: const EdgeInsets.all(Dimensions.paddingSizeVeryTiny),
      disableDefaultTargetGestures: true,
      disableBarrierInteraction: true,
      tooltipActionConfig: const TooltipActionConfig(
        alignment: MainAxisAlignment.end,
        position: TooltipActionPosition.inside,
        gapBetweenContentAndAction: Dimensions.paddingSizeMedium,
      ),
      tooltipActions: [
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          name: getTranslated('got_it', context) ?? '',
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          textStyle: robotoBold.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            color: Theme.of(context).primaryColor,
          ),
          onTap: AppModeTutorial.dismiss,
        ),
      ],
      child: chip,
    );
  }
}
