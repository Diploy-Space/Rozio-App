import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sixvalley_vendor_app/features/app_mode/controllers/app_mode_controller.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/app_mode_availability.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';

class AppModeTutorial {
  const AppModeTutorial._();

  static const String scope = 'app_mode_tutorial';
  static final GlobalKey switchButtonKey = GlobalKey(debugLabel: 'appModeSwitchShowcase');
  static ShowcaseView? _showcaseView;

  static ShowcaseView register(BuildContext context) {
    unregister();

    final AppModeController appModeController = Provider.of<AppModeController>(context, listen: false);
    final List<AppMode> availableModes = AppModeAvailability.availableModes(context);

    void markShown() => appModeController.setModeTutorialShown(availableModes);

    final ShowcaseView showcaseView = ShowcaseView.register(
      scope: scope,
      skipIfTargetNotPresent: true,
      disableBarrierInteraction: true,
      disableMovingAnimation: true,
      onFinish: markShown,
      onDismiss: (_) => markShown(),
    );
    _showcaseView = showcaseView;
    return showcaseView;
  }

  static bool get isRegistered => _showcaseView != null;

  static void unregister({ShowcaseView? owner}) {
    if (owner != null && owner != _showcaseView) return;

    _showcaseView?.unregister();
    _showcaseView = null;
  }

  static void startIfNeeded(BuildContext context) {
    final ShowcaseView? showcaseView = _showcaseView;
    if (showcaseView == null) return;

    final AppModeController appModeController = Provider.of<AppModeController>(context, listen: false);
    final List<AppMode> availableModes = AppModeAvailability.availableModes(context);

    if (!appModeController.shouldShowModeTutorial(availableModes)) return;

    showcaseView.startShowCase([switchButtonKey], delay: const Duration(milliseconds: 400));
  }

  static void dismiss() => _showcaseView?.dismiss();
}
