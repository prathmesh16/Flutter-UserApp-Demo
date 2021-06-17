import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_state.dart';
import 'package:flutter_userapp_demo/features/login/data/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit() : super(UnLoggedState());

  AuthenticationRepository authRepo = AuthenticationRepository();

  void login(String email,String password) async{
    emit(LoadingLoginState());

    await Future.delayed(const Duration(milliseconds: 2000));

    if(await authRepo.authenticateUser(email, password)) {
      emit(LoggedInState());
    } else {
      emit(ErrorLoginState());
    }
  }

  void logout() async{
    emit(LoadingLogoutState());

    authRepo.logoutUser();
    emit(UnLoggedState());
  }

  void forcedLogin() async{
    emit(ForcingLoginState());

    await Future.delayed(const Duration(milliseconds: 2000));
    if(await authRepo.checkUserExists()) {
      emit(LoggedInState());
    } else {
      emit(UnLoggedState());
    }
  }
}