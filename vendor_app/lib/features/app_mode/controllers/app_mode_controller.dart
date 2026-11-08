import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/features/app_mode/domain/enums/app_mode.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

class AppModeController with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  AppModeController({required this.sharedPreferences}) {
    _loadAppMode();
  }

  AppMode _appMode = AppMode.retail;
  AppMode get appMode => _appMode;

  void setAppMode(AppMode mode, {bool notify = true}) {
    _appMode = mode;
    sharedPreferences!.setString(AppConstants.appMode, mode.value);
    if (notify) notifyListeners();
  }

  void _loadAppMode() {
    _appMode = AppModeExtension.fromValue(sharedPreferences!.getString(AppConstants.appMode));
    notifyListeners();
  }


  bool shouldShowModeTutorial(List<AppMode> availableModes) {
    if (availableModes.length < 2) return false;

    final List<String>? seenModes = sharedPreferences!.getStringList(AppConstants.appModeTutorialModules);
    if (seenModes == null) return true;

    return availableModes.any((mode) => !seenModes.contains(mode.value));
  }

  bool shouldShowModeWelcome(AppMode mode) {
    if (mode == AppMode.retail) return false;

    final List<String>? welcomedModes = sharedPreferences!.getStringList(AppConstants.appModeWelcomedModules);
    return welcomedModes == null || !welcomedModes.contains(mode.value);
  }

  Future<void> setModeWelcomeShown(AppMode mode) async {
    final List<String> welcomedModes =
        sharedPreferences!.getStringList(AppConstants.appModeWelcomedModules) ?? <String>[];

    if (welcomedModes.contains(mode.value)) return;

    welcomedModes.add(mode.value);
    await sharedPreferences!.setStringList(AppConstants.appModeWelcomedModules, welcomedModes);
  }

  Future<void> setModeTutorialShown(List<AppMode> availableModes) async {
    await sharedPreferences!.setStringList(
      AppConstants.appModeTutorialModules,
      availableModes.map((mode) => mode.value).toList(),
    );
  }
}
