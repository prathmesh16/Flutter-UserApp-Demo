import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_event.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_state.dart';
import 'package:flutter_userapp_demo/features/login/ui/widgets/login_button.dart';
import 'package:flutter_userapp_demo/features/user_list/user_list/ui/user_list_screen.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Login Page"),
        leading: new Container(),
      ),
      body: LoginBody(),
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
      BlocProvider.of<AuthBloc>(context).add(LoginEvent(email:emailController.value.text,password:passController.value.text));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc,AuthState>(buildWhen:(previousState,state){
      if(state is LoggedState){
         Navigator.push(context, MaterialPageRoute(builder: (context) => UserListScreen(),),);
      }
      return;
    },builder: (context,state){
      if(state is ForcingLoginState){
        return Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
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
                    hintText: 'Enter your Email',
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
    });
    
  }
   Widget _buttonLogin() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'Loading ...',
            mOnPressed: () => {},
          );
        } else if (state is LoggedState) {
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