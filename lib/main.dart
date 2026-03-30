import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ── Onboarding / Auth ─────────────────────────────────────────────────────
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
// ── Core / Home ───────────────────────────────────────────────────────────
import 'features/booking/presentation/pages/home_screen.dart';
import 'features/user/presentation/pages/profile_screen.dart';
import 'features/user/presentation/pages/edit_profile_screen.dart';
import 'features/event/presentation/pages/events_screen.dart';
import 'features/community/presentation/pages/community_screen.dart';
// ── Booking ───────────────────────────────────────────────────────────────
import 'features/booking/presentation/pages/bookings_screen.dart';
import 'features/booking/presentation/pages/wishlist_screen.dart';
import 'features/user/presentation/pages/subscription_plans_screen.dart';
import 'features/booking/presentation/pages/workspace_detail_screen.dart';
import 'features/event/presentation/pages/event_detail_screen.dart';
import 'features/booking/presentation/pages/event_registration_success_screen.dart';
import 'features/chat/presentation/pages/chat_screen.dart';
import 'features/chat/presentation/pages/call_screen.dart';
import 'features/community/presentation/pages/connection_requests_screen.dart';
import 'features/booking/presentation/pages/all_workspaces_screen.dart';
import 'features/notifications/presentation/pages/notifications_screen.dart';
import 'features/user/presentation/pages/wallet_screen.dart';
import 'features/user/presentation/pages/verification_screen.dart';
import 'features/settings/presentation/pages/settings_screen.dart';
import 'features/booking/presentation/pages/qr_scanner_screen.dart';
import 'features/booking/presentation/pages/cafe_menu_screen.dart';
import 'features/user/presentation/pages/person_profile_screen.dart';
import 'features/booking/presentation/pages/booking_screen.dart';
import 'features/booking/presentation/pages/review_booking_screen.dart';
import 'features/booking/presentation/pages/map_screen.dart';

// Unified models & providers
import 'models/app_models.dart';
import 'providers/app_provider.dart';
import 'providers/user_provider.dart';
import 'utils/theme_provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/community/presentation/bloc/community_bloc.dart';
import 'features/booking/presentation/bloc/workspace_bloc.dart';
import 'features/booking/domain/entities/workspace_entity.dart';
import 'features/user/domain/entities/person_entity.dart';
import 'features/event/domain/entities/event_entity.dart';
import 'features/chat/domain/entities/chat_entity.dart';
import 'features/event/presentation/bloc/event_bloc.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

import 'widgets/zinko_background.dart';
import 'widgets/global_network_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.sl<UserBloc>(),
          ),
          BlocProvider(
            create: (_) => di.sl<BookingBloc>(),
          ),
          BlocProvider(
            create: (_) => di.sl<CommunityBloc>(),
          ),
          BlocProvider(
            create: (_) => di.sl<WorkspaceBloc>(),
          ),
          BlocProvider(
            create: (_) => di.sl<EventBloc>(),
          ),
          BlocProvider(
            create: (_) => di.sl<ChatBloc>(),
          ),
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
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            builder: (context, child) {
              return ZinkoBackground(child: child);
            },
            // ── Dynamic routes (need arguments) ──────────────
            onGenerateRoute: (settings) {
              if (settings.name == EventDetailScreen.routeName) {
                final event = settings.arguments as EventEntity;
                return MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: event),
                );
              }
              if (settings.name == ChatScreen.routeName) {
                final arg = settings.arguments;
                ZinkoChat chat;
                if (arg is ZinkoChat) {
                  chat = arg;
                } else {
                  final dynamic entity = arg;
                  chat = ZinkoChat(
                    id: entity.id,
                    name: entity.name,
                    lastMessage: entity.lastMessage,
                    time: entity.time,
                    avatar: entity.avatar,
                    unreadCount: entity.unreadCount,
                    isOnline: entity.isOnline,
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => ChatScreen(chat: chat),
                );
              }
              if (settings.name == CallScreen.routeName) {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => CallScreen(
                    chat: args['chat'] as ChatEntity,
                    isVideo: args['isVideo'] as bool,
                  ),
                );
              }
              if (settings.name == WorkspaceDetailScreen.routeName) {
                final workspace = settings.arguments as WorkspaceEntity;
                return MaterialPageRoute(
                  builder: (_) => WorkspaceDetailScreen(workspace: workspace),
                );
              }
              if (settings.name == BookingScreen.routeName) {
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_) => BookingScreen(
                    workspaceId: args?['workspaceId'] as String?,
                    workspaceName: args?['workspaceName'] as String?,
                  ),
                );
              }
              if (settings.name == PersonProfileScreen.routeName) {
                final person = settings.arguments;
                if (person is ZinkoPerson) {
                  return MaterialPageRoute(
                    builder: (_) => PersonProfileScreen(person: person),
                  );
                }
                if (person is PersonEntity) {
                  return MaterialPageRoute(
                    builder: (_) => PersonProfileScreen(person: person),
                  );
                }
              }
              return null;
            },
            // ── Static routes ─────────────────────────────────
            routes: {
              SplashScreen.routeName: (_) => const SplashScreen(),
              OnboardingScreen.routeName: (_) => const OnboardingScreen(),
              LoginScreen.routeName: (_) => const LoginScreen(),
              RegisterScreen.routeName: (_) => const RegisterScreen(),
              HomeScreen.routeName: (_) => const HomeScreen(),
              MapScreen.routeName: (_) => const MapScreen(),
              ProfileScreen.routeName: (_) => const ProfileScreen(),
              EditProfileScreen.routeName: (_) => const EditProfileScreen(),
              EventsScreen.routeName: (_) => const EventsScreen(),
              CommunityScreen.routeName: (_) => const CommunityScreen(),
              BookingsScreen.routeName: (_) => const BookingsScreen(),
              ReviewBookingScreen.routeName: (ctx) => ReviewBookingScreen(
                    bookingData: ModalRoute.of(ctx)!.settings.arguments
                        as Map<String, dynamic>,
                  ),
              EventRegistrationSuccessScreen.routeName: (_) =>
                  const EventRegistrationSuccessScreen(),
              ConnectionRequestsScreen.routeName: (_) =>
                  const ConnectionRequestsScreen(),
              AllWorkspacesScreen.routeName: (_) => const AllWorkspacesScreen(),
              NotificationsScreen.routeName: (_) => const NotificationsScreen(),
              WishlistScreen.routeName: (_) => const WishlistScreen(),
              SubscriptionPlansScreen.routeName: (_) =>
                  const SubscriptionPlansScreen(),
              WalletScreen.routeName: (_) => const WalletScreen(),
              VerificationScreen.routeName: (_) => const VerificationScreen(),
              SettingsScreen.routeName: (_) => const SettingsScreen(),
              QRScannerScreen.routeName: (ctx) => const QRScannerScreen(),
              CafeMenuScreen.routeName: (_) => const CafeMenuScreen(),
            },
          );
        },
      ),
    );
  }
}
