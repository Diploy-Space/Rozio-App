import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class NavigationService {
  static final NavigationService _navigationService =
      NavigationService._internal();
  NavigationService._internal();
  static NavigationService get instance => _navigationService;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void goTo(String routeName, {Object? extra}) {
    context!.go(routeName, extra: extra);
  }

  static void pushTo(String routeName, {Object? extra}) {
    context!.push(routeName, extra: extra);
  }

  static void replaceTo(String routeName, {Object? extra}) {
    context!.pushReplacement(routeName, extra: extra);
  }

  static void goBack() {
    if (context != null && context!.canPop()) {
      context!.pop();
    }
  }

  static bool get canGoBack => context?.canPop() ?? false;
}
