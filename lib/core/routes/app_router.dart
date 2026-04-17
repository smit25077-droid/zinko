import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';
import 'package:zinko_app/features/booking/presentation/pages/complate_cafe_list_screen.dart';
import 'package:zinko_app/features/booking/presentation/pages/booking_details_screen.dart';
import '../../features/feedback/presentation/pages/cafe_reviews_screen.dart';
import '../../features/feedback/presentation/bloc/feedback_bloc.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/booking/presentation/pages/home_screen.dart';
import '../../features/user/presentation/pages/profile_screen.dart';
import '../../features/user/presentation/pages/edit_profile_screen.dart';
import '../../features/event/presentation/pages/events_screen.dart';
import '../../features/community/presentation/pages/community_screen.dart';
import '../../features/booking/presentation/pages/bookings_screen.dart';
import '../../features/booking/presentation/pages/wishlist_screen.dart';
import '../../features/user/presentation/pages/subscription_plans_screen.dart';
import '../../features/booking/presentation/pages/workspace_detail_screen.dart';
import '../../features/event/presentation/pages/event_detail_screen.dart';
import '../../features/booking/presentation/pages/event_registration_success_screen.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/chat/presentation/pages/call_screen.dart';
import '../../features/community/presentation/pages/connection_requests_screen.dart';
import '../../features/booking/presentation/pages/all_workspaces_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/wallet/presentation/pages/wallet_screen.dart';
import '../../features/user/presentation/pages/verification_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/settings/presentation/pages/reset_password_screen.dart';
import '../../features/password_change/presentation/pages/password_change_screen.dart';
import '../../features/booking/presentation/pages/otp_check_in_screen.dart';
import '../../features/booking/presentation/pages/cafe_menu_screen.dart';
import '../../features/user/presentation/pages/person_profile_screen.dart';
import '../../features/booking/presentation/pages/booking_screen.dart';
import '../../features/booking/presentation/pages/review_booking_screen.dart';
import '../../features/booking/presentation/pages/map_screen.dart';
import '../../features/event/domain/entities/event_entity.dart';
import '../../features/booking/domain/entities/workspace_entity.dart';
import '../../features/chat/domain/entities/chat_entity.dart';
import '../../features/user/domain/entities/person_entity.dart';
import '../../models/app_models.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case OnboardingScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case MapScreen.routeName:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case EditProfileScreen.routeName:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case EventsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const EventsScreen());
      case CommunityScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      case BookingsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const BookingsScreen());
      case ReviewBookingScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReviewBookingScreen(bookingData: args),
        );
      case EventDetailScreen.routeName:
        final event = settings.arguments as EventEntity;
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(event: event),
        );
      case WorkspaceDetailScreen.routeName:
        final workspace = settings.arguments as WorkspaceEntity;
        return MaterialPageRoute(
          builder: (_) => WorkspaceDetailScreen(workspace: workspace),
        );
      case BookingScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(
            workspaceId: args?['workspaceId'] as String?,
            workspaceName: args?['workspaceName'] as String?,
            workspace: args?['workspace'] as WorkspaceEntity?,
          ),
        );
      case ChatScreen.routeName:
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
        return MaterialPageRoute(builder: (_) => ChatScreen(chat: chat));
      case CallScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CallScreen(
            chat: args['chat'] as ChatEntity,
            isVideo: args['isVideo'] as bool,
          ),
        );
      case PersonProfileScreen.routeName:
        final person = settings.arguments;
        if (person is ZinkoPerson) {
          return MaterialPageRoute(
              builder: (_) => PersonProfileScreen(person: person));
        }
        if (person is PersonEntity) {
          return MaterialPageRoute(
              builder: (_) => PersonProfileScreen(person: person));
        }
        return null;
      case EventRegistrationSuccessScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const EventRegistrationSuccessScreen());
      case ConnectionRequestsScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const ConnectionRequestsScreen());
      case AllWorkspacesScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AllWorkspacesScreen());
      case NotificationsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case WishlistScreen.routeName:
        return MaterialPageRoute(builder: (_) => const WishlistScreen());
      case SubscriptionPlansScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const SubscriptionPlansScreen());
      case WalletScreen.routeName:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case VerificationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case SettingsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case ResetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case PasswordChangeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const PasswordChangeScreen());
      case OTPCheckInScreen.routeName:
        return MaterialPageRoute(builder: (_) => const OTPCheckInScreen(),settings: settings);
      case CafeMenuScreen.routeName:
        return MaterialPageRoute(builder: (_) => const CafeMenuScreen());
      case CompleteCafeListScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => GetIt.instance<FeedbackBloc>(),
            child: const CompleteCafeListScreen(),
          ),
        );
      case CafeReviewsScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => GetIt.instance<FeedbackBloc>(),
            child: CafeReviewsScreen(
              cafeId: args['cafeId'] as int,
              cafeName: args['cafeName'] as String,
            ),
          ),
        );
      case BookingDetailsScreen.routeName:
        final booking = settings.arguments as UserBookingEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => GetIt.instance<FeedbackBloc>(),
            child: BookingDetailsScreen(booking: booking),
          ),
        );
      default:
        final prefs = GetIt.instance<SharedPreferences>();
        final hasToken = prefs.containsKey('CACHED_USER_DATA');
        return MaterialPageRoute(
          builder: (_) => hasToken ? const HomeScreen() : const SplashScreen(),
        );
    }
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    final prefs = GetIt.instance<SharedPreferences>();
    final hasToken = prefs.containsKey('CACHED_USER_DATA');
    return MaterialPageRoute(
      builder: (_) => hasToken ? const HomeScreen() : const SplashScreen(),
    );
  }

  static void safetyPop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      final prefs = GetIt.instance<SharedPreferences>();
      final hasToken = prefs.containsKey('CACHED_USER_DATA');
      Navigator.of(context).pushNamedAndRemoveUntil(
        hasToken ? HomeScreen.routeName : SplashScreen.routeName,
        (route) => false,
      );
    }
  }

  static Map<String, WidgetBuilder> get routes => {
        // You can still keep static routes here if needed,
        // but generateRoute handles everything now.
      };
}
