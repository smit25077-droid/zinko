# Utils - Common Files Usage Guide

This folder contains common utility files for colors, themes, and routes.

## Files Overview

### 1. app_colors.dart
Centralized color definitions for light and dark themes.

**Usage:**
```dart
import 'package:zinko_app/utils/app_colors.dart';

Container(
  color: AppColors.primaryLight,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimaryLight),
  ),
)
```

### 2. app_theme.dart
Light and dark theme configurations using Material 3.

**Usage in main.dart:**
```dart
import 'package:zinko_app/utils/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // or use ThemeProvider
)
```

### 3. app_routes.dart
Centralized route management with helper methods.

**Usage in main.dart:**
```dart
import 'package:zinko_app/utils/app_routes.dart';

MaterialApp(
  onGenerateRoute: AppRoutes.generateRoute,
  initialRoute: AppRoutes.home,
)
```

**Navigation examples:**
```dart
// Navigate to a route
AppRoutes.navigateTo(context, AppRoutes.login);

// Navigate with arguments
AppRoutes.navigateTo(context, AppRoutes.profile, arguments: userId);

// Replace current route
AppRoutes.navigateReplaceTo(context, AppRoutes.home);

// Clear stack and navigate
AppRoutes.navigateAndRemoveUntil(context, AppRoutes.login);

// Go back
AppRoutes.goBack(context);
```

## Integration Steps

1. Update your screen imports in app_routes.dart
2. Replace ThemeProvider.lightTheme with AppTheme.lightTheme in main.dart
3. Use AppRoutes for navigation instead of Navigator.pushNamed
4. Use AppColors throughout your widgets for consistent theming
