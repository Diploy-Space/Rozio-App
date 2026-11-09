import 'package:go_router/go_router.dart';
import 'package:rozio_app/features/auth/presentation/login_screen.dart';
import 'package:rozio_app/features/chose_language/presentation/chose_language_screen.dart';
import 'package:rozio_app/features/location/presentation/location_found_screen.dart';
import 'package:rozio_app/features/location/presentation/location_screen.dart';
import 'package:rozio_app/features/location/presentation/pincode_screen.dart';
import 'package:rozio_app/features/onboarding_screen.dart';
import 'package:rozio_app/features/splash_screen.dart';
import 'package:rozio_app/helpers/navigation_service.dart';
import 'package:geolocator/geolocator.dart';

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
      GoRoute(
        path: LocationScreen.routeName,
        name: LocationScreen.routeName,
        builder: (context, state) => const LocationScreen(),
      ),
      GoRoute(
        path: LocationFoundScreen.routeName,
        name: LocationFoundScreen.routeName,
        builder: (context, state) => LocationFoundScreen(
          position: state.extra as Position?,
        ),
      ),
      GoRoute(
        path: PincodeScreen.routeName,
        name: PincodeScreen.routeName,
        builder: (context, state) => const PincodeScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        name: LoginScreen.routeName,
        builder: (context, state) {
          final isFromBag = state.uri.queryParameters['fromBag'] == 'true';
          return LoginScreen(
            variant: isFromBag ? LoginVariant.fromAddToBag : LoginVariant.standard,
          );
        },
      ),
    ],
  );
}
