import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/add_money.dart';
import '../../domain/usecases/redeem_referral.dart';
import '../../../../core/usecases/usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final AddMoney addMoney;
  final RedeemReferral redeemReferral;

  UserBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.addMoney,
    required this.redeemReferral,
  }) : super(UserInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<SetMembershipEvent>(_onSetMembership);
    on<AddMoneyEvent>(_onAddMoney);
    on<RedeemReferralEvent>(_onRedeemReferral);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<VerifyPhoneEvent>(_onVerifyPhone);
  }

  Future<void> _onGetUserProfile(
      GetUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getUserProfile(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await updateUserProfile(UpdateUserParams(
      name: event.name,
      email: event.email,
      phone: event.phone,
      role: event.role,
      bio: event.bio,
      profileImage: event.profileImage,
      membership: event.membership,
    ));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onSetMembership(
      SetMembershipEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final user = (state as UserLoaded).user;

      final result = await updateUserProfile(UpdateUserParams(
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        bio: user.bio,
        membership: event.membership,
      ));

      result.fold(
        (failure) => emit(UserError(failure.message)),
        (updatedUser) {
          emit(UserLoaded(updatedUser));
          emit(UserMembershipUpdateSuccess(updatedUser, event.membership));
        },
      );
    }
  }

  Future<void> _onAddMoney(AddMoneyEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await addMoney(event.amount);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onRedeemReferral(
      RedeemReferralEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await redeemReferral(event.code);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onVerifyEmail(
      VerifyEmailEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final user = (state as UserLoaded).user;
      emit(UserLoading());
      final result = await updateUserProfile(UpdateUserParams(
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        bio: user.bio,
        isEmailVerified: true,
      ));
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    }
  }

  Future<void> _onVerifyPhone(
      VerifyPhoneEvent event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final user = (state as UserLoaded).user;
      emit(UserLoading());
      final result = await updateUserProfile(UpdateUserParams(
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        bio: user.bio,
        isPhoneVerified: true,
      ));
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    }
  }
}
