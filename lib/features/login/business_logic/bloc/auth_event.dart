abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String email;
  String password;
  LoginEvent({this.email,this.password});
}

class LogOutEvent extends AuthEvent {}

class ForceLoginEvent extends AuthEvent {}

class ErrorLoginEvent extends AuthEvent {}

// class LoginLoadingEvent extends AuthEvent {}

// class LogOutLoadingEvent extends AuthEvent {}