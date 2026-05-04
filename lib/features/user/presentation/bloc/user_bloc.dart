import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/user/domain/usecases/get_user_profile.dart';
import 'package:zinko_app/features/user/domain/usecases/update_user_profile.dart';
import 'package:zinko_app/features/user/domain/usecases/add_money.dart';
import 'package:zinko_app/features/user/domain/usecases/redeem_referral.dart';
import 'package:zinko_app/features/user/domain/usecases/update_visibility.dart';
import 'package:zinko_app/features/user/domain/usecases/send_email_otp.dart';
import 'package:zinko_app/features/user/domain/usecases/verify_email_otp.dart';
import 'package:zinko_app/features/user/domain/usecases/delete_user.dart';
import 'package:zinko_app/features/user/domain/usecases/change_password.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final AddMoney addMoney;
  final RedeemReferral redeemReferral;
  final UpdateVisibility updateVisibility;
  final SendEmailOtp sendEmailOtp;
  final VerifyEmailOtp verifyEmailOtp;
  final DeleteUser deleteUser;
  final ChangePassword changePassword;

  UserBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.addMoney,
    required this.redeemReferral,
    required this.updateVisibility,
    required this.sendEmailOtp,
    required this.verifyEmailOtp,
    required this.deleteUser,
    required this.changePassword,
  }) : super(UserInitial()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    // on<SetMembershipEvent>(_onSetMembership);
    on<AddMoneyEvent>(_onAddMoney);
    on<RedeemReferralEvent>(_onRedeemReferral);
    on<UpdateVisibilityEvent>(_onUpdateVisibility);
    on<SendEmailOtpEvent>(_onSendEmailOtp);
    on<VerifyEmailOtpEvent>(_onVerifyEmailOtp);
    on<VerifyPhoneEvent>(_onVerifyPhone);
    on<DeleteUserEvent>(_onDeleteUser);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ResetUserEvent>(_onResetUser);
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await deleteUser(event.userCode);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (success) => emit(UserDeleted()),
    );
  }

  Future<void> _onGetUserProfile(
      GetUserProfileEvent event, Emitter<UserState> emit) async {
    if (state is UserLoading) return;
    emit(UserLoading());
    final result = await getUserProfile(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    if (state is UserLoading) return;
    emit(UserLoading());
    final result = await updateUserProfile(UpdateUserParams(
      name: event.name,
      email: event.email,
      phone: event.phone,
      role: event.role,
      bio: event.bio,
      userCode: event.userCode,
      profileImage: event.profileImage,
      membership: event.membership,
      city: event.city,
      state: event.state,
      gender: event.gender,
      birthdate: event.birthdate,
      companyName: event.companyName,
    ));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  // Future<void> _onSetMembership(
  //     SetMembershipEvent event, Emitter<UserState> emit) async {
  //   if (state is UserLoaded) {
  //     final user = (state as UserLoaded).user;
  //
  //     final result = await updateUserProfile(UpdateUserParams(
  //       name: user.name,
  //       email: user.email,
  //       phone: user.phone,
  //       role: user.role,
  //       bio: user.bio,
  //       userCode: user.userCode,
  //       membership: event.membership,
  //     ));
  //
  //     result.fold(
  //       (failure) => emit(UserError(failure.message)),
  //       (updatedUser) {
  //         emit(UserLoaded(updatedUser));
  //         emit(UserMembershipUpdateSuccess(updatedUser, event.membership));
  //       },
  //     );
  //   }
  // }

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

  Future<void> _onVerifyEmailOtp(
      VerifyEmailOtpEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await verifyEmailOtp(VerifyEmailOtpParams(
      userCode: event.userCode,
      otp: event.otp,
    ));

    await result.fold(
      (failure) async => emit(UserError(failure.message)),
      (success) async {
        final profileResult = await getUserProfile(NoParams());
        profileResult.fold(
          (failure) => emit(UserError(failure.message)),
          (user) => emit(UserLoaded(user)),
        );
      },
    );
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
        userCode: user.userCode,
        isPhoneVerified: true,
      ));
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    }
  }

  Future<void> _onUpdateVisibility(
      UpdateVisibilityEvent event, Emitter<UserState> emit) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      final result = await updateVisibility(event.visibility);
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (newVisibility) {
          final updatedUser =
              currentState.user.copyWith(userVisibility: newVisibility);
          emit(UserLoaded(updatedUser));
        },
      );
    }
  }

  Future<void> _onSendEmailOtp(
      SendEmailOtpEvent event, Emitter<UserState> emit) async {
    final currentState = state;
    emit(UserLoading());
    final result = await sendEmailOtp(event.email);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (success) {
        if (currentState is UserLoaded) {
          emit(currentState);
        } else {
          add(GetUserProfileEvent());
        }
      },
    );
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await changePassword(ChangePasswordParams(
      userCode: event.userCode,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (success) => emit(PasswordChanged("Password Change Successfully")),
    );
  }

  void _onResetUser(ResetUserEvent event, Emitter<UserState> emit) {
    emit(UserInitial());
  }
}
