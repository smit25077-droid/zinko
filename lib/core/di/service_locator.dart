import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../network/dio_client.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../../features/booking/presentation/bloc/map/map_bloc.dart';
import '../../features/user/data/datasources/user_remote_data_source.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/booking/data/datasources/booking_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/add_booking.dart';
import '../../features/booking/domain/usecases/complete_booking.dart';
import '../../features/booking/domain/usecases/get_bookings.dart';
import '../../features/booking/domain/usecases/get_user_bookings.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/booking/presentation/bloc/selection/booking_selection_bloc.dart';
import '../../features/booking/presentation/bloc/cafe/cafe_menu_bloc.dart';
import '../../features/user/domain/usecases/get_user_profile.dart';
import '../../features/user/domain/usecases/update_user_profile.dart';
import '../../features/user/domain/usecases/add_money.dart';
import '../../features/user/domain/usecases/redeem_referral.dart';
import '../../features/user/domain/usecases/update_visibility.dart';
import '../../features/user/domain/usecases/send_email_otp.dart';
import '../../features/user/domain/usecases/verify_email_otp.dart';
import '../../features/user/domain/usecases/delete_user.dart';
import '../../features/user/presentation/bloc/user_bloc.dart';
import '../../features/booking/domain/usecases/user_check_in.dart';
import '../../features/community/domain/repositories/community_repository.dart';
import '../../features/community/data/repositories/community_repository_impl.dart';
import '../../features/community/data/datasources/community_remote_data_source.dart';
import '../../features/community/domain/usecases/post_usecases.dart';
import '../../features/community/domain/usecases/group_usecases.dart';
import '../../features/community/domain/usecases/person_usecases.dart';
import '../../features/community/presentation/bloc/community_bloc.dart';
import '../../features/booking/presentation/bloc/create_booking/create_booking_bloc.dart';
import '../../features/booking/presentation/bloc/workspace_bloc.dart';
import '../../features/booking/domain/usecases/create_booking.dart';
import '../../features/booking/domain/usecases/get_workspaces.dart';
import '../../features/booking/domain/usecases/search_workspaces.dart';
import '../../features/booking/domain/repositories/workspace_repository.dart';
import '../../features/booking/data/repositories/workspace_repository_impl.dart';
import '../../features/booking/data/datasources/workspace_local_data_source.dart';
import '../../features/event/domain/repositories/event_repository.dart';
import '../../features/event/data/repositories/event_repository_impl.dart';
import '../../features/event/data/datasources/event_remote_data_source.dart';
import '../../features/event/domain/usecases/event_usecases.dart';
import '../../features/event/presentation/bloc/event_bloc.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/domain/usecases/chat_usecases.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/cafe/domain/repositories/cafe_repository.dart';
import '../../features/cafe/data/repositories/cafe_repository_impl.dart';
import '../../features/cafe/data/datasources/cafe_remote_data_source.dart';
import '../../features/cafe/domain/usecases/search_cafes.dart';
import '../../features/cafe/presentation/bloc/cafe_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    //! External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => DioClient(sl(), sl()));

    //! Splash Video Pre-initialization
    final showStartupVideo =
        sharedPreferences.getBool('show_startup_video') ?? true;
    if (showStartupVideo) {
      final controller =
          VideoPlayerController.asset('assets/images/zinko_video.mp4');
      try {
        // Pre-warm the controller
        await controller.initialize().timeout(const Duration(seconds: 5));
        sl.registerSingleton<VideoPlayerController>(controller);
      } catch (e) {
        // If it fails, we'll try again in the splash screen or show logo
        print('DI: Splash video pre-init failed: $e');
      }
    }

    //! Features - Auth (Clean Architecture)
    // BLoC
    sl.registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        repository: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => RegisterUseCase(sl()));

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );

    // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: sl()),
    );
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
    );

    //! Features - User
    // BLoC
    sl.registerFactory(
      () => UserBloc(
        getUserProfile: sl(),
        updateUserProfile: sl(),
        addMoney: sl(),
        redeemReferral: sl(),
        updateVisibility: sl(),
        sendEmailOtp: sl(),
        verifyEmailOtp: sl(),
        deleteUser: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetUserProfile(sl()));
    sl.registerLazySingleton(() => UpdateUserProfile(sl()));
    sl.registerLazySingleton(() => AddMoney(sl()));
    sl.registerLazySingleton(() => RedeemReferral(sl()));
    sl.registerLazySingleton(() => UpdateVisibility(sl()));
    sl.registerLazySingleton(() => SendEmailOtp(sl()));
    sl.registerLazySingleton(() => VerifyEmailOtp(sl()));
    sl.registerLazySingleton(() => DeleteUser(sl()));

    //! Features - Booking
    // Use cases
    sl.registerLazySingleton(() => GetBookings(sl()));
    sl.registerLazySingleton(() => GetUserBookings(sl()));
    sl.registerLazySingleton(() => UserCheckIn(sl()));
    sl.registerLazySingleton(() => AddBooking(sl()));
    sl.registerLazySingleton(() => CompleteBooking(sl()));
    sl.registerLazySingleton(() => GetWorkspaces(sl()));
    sl.registerLazySingleton(() => SearchWorkspaces(sl()));
    sl.registerLazySingleton(() => CreateBookingUseCase(sl()));

    // BLoC
    sl.registerFactory(
      () => BookingBloc(
        getBookings: sl(),
        getUserBookings: sl(),
        userCheckIn: sl(),
        addBooking: sl(),
        completeBooking: sl(),
        repository: sl(),
      ),
    );

    // BLoC - Workspace
    sl.registerFactory(
      () => WorkspaceBloc(
        getWorkspaces: sl(),
        searchWorkspaces: sl(),
        repository: sl(),
      ),
    );
    sl.registerFactory(() => CreateBookingBloc(createBookingUseCase: sl()));

    // Repository
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<WorkspaceRepository>(
      () => WorkspaceRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    );

    // Data source
    sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(
        client: sl(),
        sharedPreferences: sl(),
      ),
    );
    sl.registerLazySingleton<WorkspaceLocalDataSource>(
      () => WorkspaceLocalDataSourceImpl(),
    );

    //! Features - Community
    // BLoC
    sl.registerFactory(
      () => CommunityBloc(
        getPosts: sl(),
        toggleLikePost: sl(),
        getGroups: sl(),
        toggleJoinGroup: sl(),
        getPeople: sl(),
        toggleConnection: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetPosts(sl()));
    sl.registerLazySingleton(() => ToggleLikePost(sl()));
    sl.registerLazySingleton(() => GetGroups(sl()));
    sl.registerLazySingleton(() => ToggleJoinGroup(sl()));
    sl.registerLazySingleton(() => GetPeople(sl()));
    sl.registerLazySingleton(() => ToggleConnection(sl()));

    // Repository
    sl.registerLazySingleton<CommunityRepository>(
      () => CommunityRepositoryImpl(remoteDataSource: sl()),
    );

    // Data source
    sl.registerLazySingleton<CommunityRemoteDataSource>(
      () => CommunityRemoteDataSourceImpl(),
    );

    //! Data sources (User) - move to appropriate section if needed
    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()),
    );

    //! Features - Event
    // BLoC
    sl.registerFactory(
      () => EventBloc(
        getEvents: sl(),
        toggleFavoriteEvent: sl(),
        registerEvent: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetEvents(sl()));
    sl.registerLazySingleton(() => ToggleFavoriteEvent(sl()));
    sl.registerLazySingleton(() => RegisterEvent(sl()));

    // Repository
    sl.registerLazySingleton<EventRepository>(
      () => EventRepositoryImpl(remoteDataSource: sl()),
    );

    // Data source
    sl.registerLazySingleton<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(),
    );

    //! Features - Chat
    // BLoC
    sl.registerFactory(
      () => ChatBloc(
        getChats: sl(),
        getMessages: sl(),
        sendChatMessage: sl(),
      ),
    );

    // Use cases
    sl.registerLazySingleton(() => GetChats(sl()));
    sl.registerLazySingleton(() => GetMessages(sl()));
    sl.registerLazySingleton(() => SendMessage(sl()));

    // Repository
    sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: sl()),
    );

    // Data source
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(),
    );

    //! Core
    sl.registerFactory(() => BookingSelectionBloc());
    sl.registerFactory(() => CafeMenuBloc(bookingBloc: sl()));
    sl.registerFactory(() => NavigationBloc());
    sl.registerFactory(() => MapBloc(getWorkspaces: sl(), getPeople: sl()));

    //! Features - Cafe
    // BLoC
    sl.registerFactory(() => CafeBloc(searchCafes: sl()));

    // Use cases
    sl.registerLazySingleton(() => SearchCafes(repository: sl()));

    // Repository
    sl.registerLazySingleton<CafeRepository>(
      () => CafeRepositoryImpl(remoteDataSource: sl()),
    );

    // Data source
    sl.registerLazySingleton<CafeRemoteDataSource>(
      () => CafeRemoteDataSourceImpl(client: sl(), sharedPreferences: sl()),
    );
  }
}
