import 'package:go_router/go_router.dart';
import 'package:rozio_app/features/chose_language/presentation/chose_language_screen.dart';
import 'package:rozio_app/features/onboarding_screen.dart';
import 'package:rozio_app/features/splash_screen.dart';
import 'package:rozio_app/helpers/navigation_service.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.routeName,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: ChoseLanguageScreen.routeName,
        name: ChoseLanguageScreen.routeName,
        builder: (context, state) => const ChoseLanguageScreen(),
      ),
    ],
  );
}
