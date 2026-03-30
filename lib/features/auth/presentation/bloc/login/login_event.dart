abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({
    required this.email,
    required this.password,
  });
}

class TogglePasswordVisibility extends LoginEvent {}

class ToggleRememberMe extends LoginEvent {
  final bool rememberMe;
  ToggleRememberMe(this.rememberMe);
}

