import 'package:get_it/get_it.dart';
import 'core/bloc/navigation/navigation_bloc.dart';
import 'features/booking/presentation/bloc/map/map_bloc.dart';
import '../features/user/data/datasources/user_remote_data_source.dart';
import '../features/user/data/repositories/user_repository_impl.dart';
import '../features/user/domain/repositories/user_repository.dart';
import '../features/booking/data/datasources/booking_remote_data_source.dart';
import '../features/booking/data/repositories/booking_repository_impl.dart';
import '../features/booking/domain/repositories/booking_repository.dart';
import '../features/booking/domain/usecases/add_booking.dart';
import '../features/booking/domain/usecases/complete_booking.dart';
import '../features/booking/domain/usecases/get_bookings.dart';
import '../features/booking/presentation/bloc/booking_bloc.dart';
import '../features/booking/presentation/bloc/selection/booking_selection_bloc.dart';
import '../features/booking/presentation/bloc/cafe/cafe_menu_bloc.dart';
import '../features/user/domain/usecases/get_user_profile.dart';
import '../features/user/domain/usecases/update_user_profile.dart';
import '../features/user/domain/usecases/add_money.dart';
import '../features/user/domain/usecases/redeem_referral.dart';
import '../features/user/presentation/bloc/user_bloc.dart';

// Community imports
import '../features/community/domain/repositories/community_repository.dart';
import '../features/community/data/repositories/community_repository_impl.dart';
import '../features/community/data/datasources/community_remote_data_source.dart';
import '../features/community/domain/usecases/post_usecases.dart';
import '../features/community/domain/usecases/group_usecases.dart';
import '../features/community/domain/usecases/person_usecases.dart';
import '../features/community/presentation/bloc/community_bloc.dart';

import '../features/booking/presentation/bloc/workspace_bloc.dart';
import '../features/booking/domain/usecases/get_workspaces.dart';
import '../features/booking/domain/repositories/workspace_repository.dart';
import '../features/booking/data/repositories/workspace_repository_impl.dart';
import '../features/booking/data/datasources/workspace_local_data_source.dart';

// Event imports
import '../features/event/domain/repositories/event_repository.dart';
import '../features/event/data/repositories/event_repository_impl.dart';
import '../features/event/data/datasources/event_remote_data_source.dart';
import '../features/event/domain/usecases/event_usecases.dart';
import '../features/event/presentation/bloc/event_bloc.dart';

// Chat imports
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/domain/usecases/chat_usecases.dart';
import '../features/chat/presentation/bloc/chat_bloc.dart';
import '../features/auth/presentation/bloc/login/login_bloc.dart';
import '../features/auth/presentation/bloc/register/register_bloc.dart';
import '../features/auth/domain/usecases/login.dart';
import '../features/auth/domain/usecases/register.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  sl.registerFactory(
    () => LoginBloc(
      login: sl(),
    ),
  );
  sl.registerFactory(
    () => RegisterBloc(
      register: sl(),
    ),
  );

  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  //! Features - User
  // BLoC
  sl.registerFactory(
    () => UserBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      addMoney: sl(),
      redeemReferral: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => AddMoney(sl()));
  sl.registerLazySingleton(() => RedeemReferral(sl()));

  //! Features - Booking
  // BLoC
  sl.registerFactory(
    () => BookingBloc(
      getBookings: sl(),
      addBooking: sl(),
      completeBooking: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetBookings(sl()));
  sl.registerLazySingleton(() => AddBooking(sl()));
  sl.registerLazySingleton(() => CompleteBooking(sl()));
  sl.registerLazySingleton(() => GetWorkspaces(sl()));

  // BLoC - Workspace
  sl.registerFactory(
    () => WorkspaceBloc(
      getWorkspaces: sl(),
      repository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(localDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(),
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
    () => UserRemoteDataSourceImpl(),
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
}
