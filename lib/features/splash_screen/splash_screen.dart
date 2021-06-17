import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_state.dart';
import 'package:flutter_userapp_demo/features/user_list/ui/user_list/user_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_cubit.dart';
import 'package:flutter_userapp_demo/features/login/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().forcedLogin();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(
        buildWhen: (previousState,state){
          if(state is LoggedInState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserListScreen(),
              ),
            );
            return false;
          } else if(state is UnLoggedState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
            return false;
          }
          return true;
        },
        builder: (context,state) {
            return SplashScreenBody();
        },
      );
  }
}

class SplashScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(top:150),
              child: Image.asset("assets/flutter.png"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("User App",style: TextStyle(fontFamily: "Lalezar",fontSize: 50),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}