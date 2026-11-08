import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';

class AppModeAvailability {
  const AppModeAvailability._();

  static bool isAuctionEnabled(BuildContext context) {
    final configModel = Provider.of<SplashController>(context, listen: false).configModel;
    return configModel?.isAuctionFeatureEnabled == true && configModel?.activeAuctionForVendor == true;
  }

  static bool isWholesaleEnabled(BuildContext context) {
    return Provider.of<SplashController>(context, listen: false).configModel?.isWholesaleFeatureEnabled == true;
  }

  static List<AppMode> availableModes(BuildContext context) {
    final bool auctionEnabled = isAuctionEnabled(context);
    final bool wholesaleEnabled = isWholesaleEnabled(context);

    return AppMode.values.where((mode) {
      switch (mode) {
        case AppMode.auction:
          return auctionEnabled;
        case AppMode.wholesale:
          return wholesaleEnabled;
        case AppMode.retail:
          return true;
      }
    }).toList();
  }

  static bool canSwitchMode(BuildContext context) => availableModes(context).length > 1;
}
