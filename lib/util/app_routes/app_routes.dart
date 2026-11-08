import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rozio_app/features/splash_screen.dart';


class AppRoutes {
  static int duration = 300;



  static final appRoutes = [
    defaultTransitionPage(
      name: SplashScreen.routeName,
      page: () => SplashScreen(),
    ),
    

    // dynamicArgumentPage(
    //   name: RoomTaskScreen.routeName,
    //   pageBuilder: (args) => RoomTaskScreen(roomId: args),
    // ),
    // // defaultTransitionPage(name: RoomTaskScreen.routeName, page: () =>  RoomTaskScreen()),
    // defaultTransitionPage(name: WattSaveScreen.routeName, page: () => WattSaveScreen()),
    // defaultTransitionPage(name: DashboardScreen.routeName, page: () => DashboardScreen()),
    // defaultTransitionPage(name: TheVaultScreen.routeName, page: () => TheVaultScreen()),
    // defaultTransitionPage(name: EquityInsightScreen.routeName, page: () => EquityInsightScreen()),
    // defaultTransitionPage(name: HomeScopeScreen.routeName, page: () => HomeScopeScreen()),

    // dynamicArgumentPage(
    //   name: HomeScopeProjectDetails.routeName,
    //   pageBuilder: (args) => HomeScopeProjectDetails(projectId: args),
    // ),

    // // read more screen
    // dynamicArgumentPage(
    //   name: ReadMoreScreen.routeName,
    //   pageBuilder: (args) => ReadMoreScreen(
    //     article: args["article"],
    //     index: args["index"],
    //   ),
    // ),
  ];
}

//
GetPage defaultTransitionPage({
  required String name,
  required GetPageBuilder page,
}) {
  return GetPage(
    name: name,
    page: page,
    transition: Transition.noTransition,
    transitionDuration: Duration(milliseconds: AppRoutes.duration),
  );
}

// for argument pass route
GetPage dynamicArgumentPage({
  required String name,
  required Widget Function(dynamic args) pageBuilder,
}) {
  return GetPage(
    name: name,
    page: () => pageBuilder(Get.arguments),
    transition: Transition.noTransition,
    transitionDuration: Duration(milliseconds: AppRoutes.duration),
  );
}
