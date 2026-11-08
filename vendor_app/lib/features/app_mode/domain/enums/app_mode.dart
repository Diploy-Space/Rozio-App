import 'package:sixvalley_vendor_app/utill/images.dart';

enum AppMode {
  retail,
  auction,
  wholesale,
}

extension AppModeExtension on AppMode {
  String get value => name;

  String get icon {
    switch (this) {
      case AppMode.retail:
        return Images.retailIcon;
      case AppMode.auction:
        return Images.auctionIcon;
      case AppMode.wholesale:
        return Images.wholesaleIcon;
    }
  }

  String get titleKey {
    switch (this) {
      case AppMode.retail:
        return 'retail';
      case AppMode.auction:
        return 'auction';
      case AppMode.wholesale:
        return 'wholesale';
    }
  }

  String get descriptionKey {
    switch (this) {
      case AppMode.retail:
        return 'retail_mode_description';
      case AppMode.auction:
        return 'auction_mode_description';
      case AppMode.wholesale:
        return 'wholesale_mode_description';
    }
  }

  static AppMode fromValue(String? value) {
    return AppMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => AppMode.retail,
    );
  }
}
