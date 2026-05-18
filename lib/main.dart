import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/navigation/navigation_bloc.dart';
import 'package:zinko_app/widgets/zinko_background.dart';

// Core
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/core/bloc/app_bloc_observer.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/utils/theme_provider.dart';
import 'package:zinko_app/providers/app_provider.dart';
import 'package:zinko_app/providers/user_provider.dart';
import 'package:zinko_app/widgets/global_network_overlay.dart';

// Features
import 'package:zinko_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zinko_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/community/presentation/bloc/community_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/workspace_bloc.dart';
import 'package:zinko_app/features/event/presentation/bloc/event_bloc.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_bloc.dart';
import 'package:zinko_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:zinko_app/features/password_change/presentation/bloc/password_change_bloc.dart';

// Final GlobalKey is imported from widgets/global_network_overlay.dart
// developerzinko
// 1999Moksh@
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ServiceLocator.init();
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<UserBloc>()),
          BlocProvider(create: (_) => sl<CommunityBloc>()),
          BlocProvider(create: (_) => sl<WorkspaceBloc>()),
          BlocProvider(create: (_) => sl<EventBloc>()),
          BlocProvider(create: (_) => sl<AuthBloc>()..add(CheckAuthStatus())),
          BlocProvider(create: (_) => sl<CafeBloc>()),
          BlocProvider(create: (_) => sl<ChatBloc>()),
          BlocProvider(create: (_) => sl<BookingBloc>()),
          BlocProvider(create: (_) => sl<WalletBloc>()),
          BlocProvider(create: (_) => sl<PasswordChangeBloc>()),
          BlocProvider(create: (_) => sl<NavigationBloc>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalNetworkOverlay(
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: zinkoNavigatorKey,
            title: 'ZINKO',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: AppRouter.generateRoute,
            onUnknownRoute: AppRouter.onUnknownRoute,
            builder: (context, child) {
              return ZinkoBackground(
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                    child: child ?? const SizedBox.shrink()),
              );
            },
          );
        },
      ),
    );
  }
}

// class KeyboardUnfocusWrapper extends StatefulWidget {
//   final Widget child;
//   const KeyboardUnfocusWrapper({super.key, required this.child});
//
//   @override
//   State<KeyboardUnfocusWrapper> createState() => _KeyboardUnfocusWrapperState();
// }
//
// class _KeyboardUnfocusWrapperState extends State<KeyboardUnfocusWrapper>
//     with WidgetsBindingObserver {
//   bool _isKeyboardVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeMetrics() {
//     super.didChangeMetrics();
//     final bottomInset = View.of(context).viewInsets.bottom;
//     final isVisible = bottomInset > 0;
//
//     if (_isKeyboardVisible && !isVisible) {
//       // Keyboard has been closed
//       FocusManager.instance.primaryFocus?.unfocus();
//     }
//     _isKeyboardVisible = isVisible;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         // Only unfocus if the tap is on the background (not on a keyboard/textfield)
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
//           FocusManager.instance.primaryFocus?.unfocus();
//         }
//       },
//       child: widget.child,
//     );
//   }
// }
