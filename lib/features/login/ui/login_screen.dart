import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_cubit.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_state.dart';
import 'package:flutter_userapp_demo/features/login/ui/widgets/login_button.dart';
import 'package:flutter_userapp_demo/features/user_list/ui/user_list/user_list_screen.dart';


class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
        appBar: AppBar(
          title: new Text("Login Page"),
          leading: new Container(),
        ),
        body: LoginBody(),
      ),
      onWillPop:() => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            ),
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBody extends StatefulWidget{
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody>{

  final emailController = TextEditingController();
  final passController = TextEditingController();

  void _login() {
    //validate
    if(emailController.value.text!="" && passController.value.text!="") {
      context.read<AuthCubit>().login(emailController.value.text, passController.value.text);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit,AuthState>(buildWhen:(previousState,state){
      if(state is LoggedInState){
         Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserListScreen(),
            ),
          );
          return false;
      }
      return true;
    },builder: (context,state){
        return Container(
          padding:EdgeInsets.all(20),
          color:Colors.white,
          child: ListView(
            children: <Widget>[
              Container(
                height: 150.0,
                width: 190.0,
                margin: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Center(
                  child: Image.asset('assets/login.jpg'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your Email'
                  ),
                  controller: emailController,
                ),
              ),
              SizedBox(
                height:10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your Password'
                  ),
                  controller: passController,
                ),
              ),
              _buttonLogin(),
              Container(
                margin: EdgeInsets.only(top:10),
                alignment: Alignment.center,
                child:  Text('New User? Create Account'),
              )
            ],
          ),
        );
    }
    );
  }
   Widget _buttonLogin() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'Loading ...',
            mOnPressed: () => {},
          );
        } else if (state is LoggedInState) {
          return ButtonLogin(
            backgroundColor: Colors.blue,
            label: 'Logging In!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            isError:(state is ErrorLoginState)?true:false,
            backgroundColor: Colors.blue,
            label: 'Sign In',
            mOnPressed: () => _login(),
          );
        }
      },
    );
  }
}