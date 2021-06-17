import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_event.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_state.dart';
import 'package:flutter_userapp_demo/features/login/data/authentication_repository.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState> {
  
  AuthBloc(AuthState initialState) : super(initialState);
  
  get initialState => UnLoggedState();

  bool _isLogged;

  AuthenticationRepository authRepo = AuthenticationRepository();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      if(event is LoginEvent) {
        
        yield LoadingLoginState();

        //check user login
        await Future.delayed(const Duration(milliseconds: 2000));
        
        if(await authRepo.authenticateUser(event.email,event.password)) {
          yield LoggedState();
        }
        else {
          yield ErrorLoginState();
        }
      }else if (event is LogOutEvent) {
        
        yield LoadingLogoutState();

        //logout user

        authRepo.logoutUser();
        yield UnLoggedState();

      }else if(event is ForceLoginEvent) {
        
        yield ForcingLoginState();

        //verify is logged
        await Future.delayed(const Duration(milliseconds: 2000));
        
        _isLogged = await authRepo.checkUserPrefrences();
        yield _isLogged ? LoggedState() : UnLoggedState();

      }else {
        yield UnLoggedState();
      }

    } catch(e) {
      yield ErrorLoginState();
    }
  }
  
}