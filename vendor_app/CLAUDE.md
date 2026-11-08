# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sixvalley Seller App** — a Flutter vendor/seller management app for the 6Valley e-commerce platform. Version 16.3, Flutter SDK ≥3.41.4, Dart ≥3.2.0.

## Common Commands

```bash
# Run the app
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ipa --release

# Analyze (lint)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Get dependencies
flutter pub get

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

## Architecture

### Feature-First Structure

All features live in `lib/features/<feature_name>/` and follow a strict layered pattern:

```
lib/features/<feature>/
├── controllers/       # ChangeNotifier classes — state + business logic
├── domain/
│   ├── models/        # Data classes (JSON serializable)
│   ├── repository/    # API calls via Dio; implements repository interface
│   └── services/      # Bridges controller ↔ repository; implements service interface
├── screens/           # Full-screen widgets; consume controller via Provider
└── widgets/           # Reusable UI components scoped to this feature
```

Each layer has a corresponding abstract interface in `domain/repository/` and `domain/services/` (e.g. `auction_product_repository_interface.dart`, `auction_product_service_interface.dart`). Always implement both the interface and the concrete class when adding a new layer.

### State Management

**Provider + ChangeNotifier.** Controllers extend `ChangeNotifier`, expose private state through public getters, and call `notifyListeners()` after mutations. Controllers are registered in `lib/main.dart` via `MultiProvider` and consumed in widgets with `Provider.of<T>(context)` or `Consumer<T>`.

### Dependency Injection

`lib/di_container.dart` uses **GetIt** (`sl`). The registration order is:

1. Shared infrastructure (Dio, SharedPreferences) as lazy singletons
2. Repositories as lazy singletons
3. Services as lazy singletons (assigned to the interface type)
4. Controllers as factories (new instance per `Provider.of` registration)

When adding a new feature, register all three layers in `di_container.dart` and add the controller to `MultiProvider` in `main.dart`.

### API Layer

- All endpoints are constants in `lib/utill/app_constants.dart`.
- Base URL is set in `APP_BASE_URL`. For local dev it points to a LAN IP (`192.168.1.218`); change this to the backend host as needed.
- HTTP is done through a centralized Dio instance injected via `sl()`. Responses are wrapped in `ApiResponse`; use `ApiChecker` for error handling.
- The API version prefix is `/api/v3/seller/`.

### Localization & Assets

- Language strings: `assets/language/en.json` (and per-locale files). Keys are added here and referenced via the localization helper.
- SVG assets: `assets/svg/`. Register new SVGs in `pubspec.yaml` under `flutter > assets`.
- Images: `assets/images/`. Image path constants live in `lib/utill/images.dart`.

## UI Theme & Fonts

### Theme System

The app supports **light and dark themes** toggled via `ThemeController` (`lib/theme/controllers/theme_controller.dart`), which persists the preference in `SharedPreferences`. The active theme is applied in `main.dart`:

```dart
theme: Provider.of<ThemeController>(context).darkTheme ? dark : light,
```

Theme definitions live in `lib/theme/light_theme.dart` and `lib/theme/dark_theme.dart`.

**Text scaling is disabled globally** (`textScaler: TextScaler.noScaling` in `main.dart`) — do not override this in individual widgets.

### Accessing Colors in Widgets

Always use `Theme.of(context)` — never hardcode hex values. The semantic mapping is:

| Token | Light | Dark | Use for |
|---|---|---|---|
| `colorScheme.primary` | `#1455AC` | `#1455AC` | Brand blue, buttons, links |
| `colorScheme.secondary` | `#F58300` | `#F58300` | Accent orange |
| `colorScheme.error` | `#FF5A5A` | `#FF4040` | Errors, destructive actions |
| `colorScheme.tertiary` | `#FFBB38` | `#FFBB38` | Warnings |
| `colorScheme.onTertiaryContainer` | `#04BB7B` | `#04BB7B` | Success states |
| `colorScheme.outline` | `#5C8FFC` | `#5C8FFC` | Info / Pending status |
| `colorScheme.surface` | `#FFFFFF` | `#242424` | Sheet/dialog backgrounds |
| `colorScheme.secondaryContainer` | `#F2F2F2` | `#F2F2F2` | Input field fills |
| `cardColor` | `#FFFFFF` | `#333333` | Card backgrounds |
| `scaffoldBackgroundColor` | `#F7F8FA` | — | Page backgrounds |
| `textTheme.bodyLarge?.color` | `#222324` | `#E9EEF4` | Primary text |
| `textTheme.bodySmall?.color` | `#A7A7A7` | `#E9EEF4` | Secondary / hint text |
| `hintColor` | `#A7A7A7` | `#C7C7C7` | Placeholder text |
| `highlightColor` | `#FFFFFF` | `#252525` | Selected/highlight tint |

For theme-aware box shadows use `ThemeShadow.getShadow(context)` (`lib/utill/styles.dart`).

### Fonts

Only **Roboto** is declared in `pubspec.yaml` (weights 400, 500, 700). The `ThemeData` declares `fontFamily: 'TitilliumWeb'` as a fallback chain, but that font is not bundled — Flutter falls back to the system font for it.

**Ubuntu** fonts exist under `assets/font/ubuntu/` but are **not declared in `pubspec.yaml`**. Do not reference `fontFamily: 'Ubuntu'` in new code until they are registered.

### Text Styles

Predefined constants in `lib/utill/styles.dart` — import and reuse these instead of constructing `TextStyle` inline:

| Constant | Family | Weight | Size | Notes |
|---|---|---|---|---|
| `titilliumRegular` | Ubuntu | 400 | 14 | Despite the name, uses Ubuntu |
| `titilliumSemiBold` | Ubuntu | 500 | 16 | |
| `titilliumBold` | Ubuntu | 600 | 14 | |
| `titilliumItalic` | Ubuntu | 400 italic | 14 | |
| `robotoRegular` | Roboto | 400 | 14 | Hard-coded black — apply `.copyWith(color: ...)` for theme awareness |
| `robotoMedium` | Roboto | 500 | 14 | |
| `robotoBold` | Roboto | 600 | 14 | |
| `robotoTitleRegular` | Roboto | 400 | 16 | |
| `robotoSmallTitleRegular` | Roboto | 400 | 12 | |
| `robotoHintRegular` | Roboto | 400 | 12 | Hard-coded grey |

> **Note:** `robotoRegular` and `robotoBold` have hard-coded `Colors.black` — always `.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)` when using them in themed screens.

### Spacing & Sizing

All spacing, radius, font size, and icon size constants live in `lib/utill/dimensions.dart`. Use these — never magic numbers.

Key constants:

```dart
// Font sizes
Dimensions.fontSizeSmall        // 12
Dimensions.fontSizeDefault      // 14
Dimensions.fontSizeLarge        // 16
Dimensions.fontSizeExtraLargeTwenty // 20
Dimensions.fontSizeOverlarge    // 24

// Padding
Dimensions.paddingSizeExtraSmall  // 5
Dimensions.paddingSizeSmall       // 10
Dimensions.paddingSizeMedium      // 15
Dimensions.paddingSizeDefault     // 20

// Border radius
Dimensions.radiusSmall    // 5
Dimensions.radiusDefault  // 10
Dimensions.radiusExtraLarge // 20

// Icons
Dimensions.iconSizeDefault  // 18
Dimensions.iconSizeMedium   // 20
Dimensions.iconSizeLarge    // 25
```

### Color Utilities

`lib/helper/color_helper.dart` provides:
- `ColorHelper.hexCodeToColor(String?)` — convert a hex string (e.g. from API) to a `Color`
- `ColorHelper.blendColors(bg, fg, opacity)` — alpha-blend two colors
- `ColorHelper.darken(color, amount)` — darken a color by HSL lightness reduction

## Key Files

| File | Purpose |
|---|---|
| `lib/main.dart` | App entry, MultiProvider setup, Firebase init |
| `lib/di_container.dart` | GetIt DI registrations for all features |
| `lib/utill/app_constants.dart` | API base URL, all endpoint strings, app config |
| `lib/utill/images.dart` | Asset path constants |
| `lib/utill/dimensions.dart` | All spacing, sizing, radius, and font-size constants |
| `lib/utill/styles.dart` | Predefined `TextStyle` constants + `ThemeShadow` |
| `lib/theme/light_theme.dart` | Light `ThemeData` definition |
| `lib/theme/dark_theme.dart` | Dark `ThemeData` definition |
| `lib/theme/controllers/theme_controller.dart` | Theme toggle logic, persisted in SharedPreferences |
| `lib/helper/color_helper.dart` | Hex→Color conversion, blend, darken utilities |
| `assets/language/en.json` | English string keys |

## Adding a New Feature

1. Create `lib/features/<name>/` with the standard folder structure above.
2. Define the model, repository interface + implementation, service interface + implementation, and controller.
3. Register repository, service, and controller in `lib/di_container.dart`.
4. Add the controller to `MultiProvider` in `lib/main.dart`.
5. Add any API endpoint constants to `lib/utill/app_constants.dart`.
6. Add new string keys to `assets/language/en.json`.
