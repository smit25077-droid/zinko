
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

  UpdateUserProfileEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.bio,
    this.profileImage,
    this.membership,
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

class VerifyEmailEvent extends UserEvent {}

class VerifyPhoneEvent extends UserEvent {}
