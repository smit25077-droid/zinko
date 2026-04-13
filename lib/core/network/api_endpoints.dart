class ApiEndpoints {
  static const String baseUrl = 'http://187.127.135.213:8090/api/';

  // Auth endpoints
  static const String login = 'auth/mobile/login';
  static const String signup = 'user/signup';
  static const String userProfile = 'user/get/user';
  static const String userVisibility = 'user/update/visibility';
  static const String searchCafes = 'cafe/search';
  static const String createBooking = 'booking/create';
  static const String getBookings = 'booking/get/user/booking/detials';
  static const String checkIn = 'booking/user/checkin';
  static const String cancelBooking = 'booking/cancel/booking';
  static const String sendEmailOtp = 'alert/send/email/for/email/verification';
  static const String verifyEmailOtp = 'user/email/verification';
  static const String deleteUser = 'user/remove';
  static const String changePassword = 'user/change/password';
  static const String sendPasswordResetOtp = 'alert/send/otp/for/password/reset';
  static const String verifyPasswordResetOtp = 'user/password/reset/otp/verification';
}
