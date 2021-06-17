abstract class AuthState {}

class LoadingLoginState extends AuthState {}

class LoadingLogoutState extends AuthState {}

class ErrorLoginState extends AuthState {}

class LoggedInState extends AuthState {}

class UnLoggedState extends AuthState {}

class ForcingLoginState extends AuthState {}
