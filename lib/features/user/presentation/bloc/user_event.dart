abstract class UserEvent {}

class GetUserProfileEvent extends UserEvent {}

class UpdateUserProfileEvent extends UserEvent {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String bio;
  final String? profileImage;
  final String? membership;
  final String? city;
  final String? state;
  final String? gender;
  final String? birthdate;
  final String? companyName;
  final int userCode;

  UpdateUserProfileEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.bio,
    required this.userCode,
    this.profileImage,
    this.membership,
    this.city,
    this.state,
    this.gender,
    this.birthdate,
    this.companyName,
  });
}

class SetMembershipEvent extends UserEvent {
  final String membership;
  SetMembershipEvent(this.membership);
}

class AddMoneyEvent extends UserEvent {
  final double amount;
  AddMoneyEvent(this.amount);
}

class RedeemReferralEvent extends UserEvent {
  final String code;
  RedeemReferralEvent(this.code);
}

class SendEmailOtpEvent extends UserEvent {
  final String email;
  SendEmailOtpEvent(this.email);
}

class VerifyEmailOtpEvent extends UserEvent {
  final String userCode;
  final String otp;
  VerifyEmailOtpEvent({required this.userCode, required this.otp});
}

class VerifyPhoneEvent extends UserEvent {}

class DeleteUserEvent extends UserEvent {
  final int userCode;
  DeleteUserEvent(this.userCode);
}

class UpdateVisibilityEvent extends UserEvent {
  final bool visibility;
  UpdateVisibilityEvent(this.visibility);
}

class ChangePasswordEvent extends UserEvent {
  final int userCode;
  final String password;
  ChangePasswordEvent({required this.userCode, required this.password});
}

class ResetUserEvent extends UserEvent {
}
