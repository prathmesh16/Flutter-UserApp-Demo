import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/favourite_user/state/favourite_users_data.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_bloc.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_event.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/bloc/auth_state.dart';
import 'package:flutter_userapp_demo/features/login/ui/login_screen.dart';
import 'package:provider/provider.dart';

import './data/constants/app_theme.dart';

void main() => runApp(Application());

//Application
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        BlocProvider(
          create:(context) => AuthBloc(UnLoggedState()),
        ),
        ChangeNotifierProvider<FavouriteUsersData>(
          create: (_) => FavouriteUsersData(),
        ),
      ],
      child:InitialScreen(),
    ); 
  }
}
class InitialScreen extends StatefulWidget {
  @override
  _InitialScreen createState() => _InitialScreen();
}

class _InitialScreen extends State<InitialScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AuthBloc>(context,listen: false).add(ForceLoginEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: themeData,
      home: LoginScreen()
    );
  }
}
