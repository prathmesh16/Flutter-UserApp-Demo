import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_userapp_demo/features/favourite_user/data/favourite_users_data.dart';
import 'package:flutter_userapp_demo/features/login/business_logic/cubit/auth_cubit.dart';
import 'package:flutter_userapp_demo/features/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'common/app_theme.dart';

void main() => runApp(Application());

//Application
class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        BlocProvider(
          create:(context) => AuthCubit(),
        ),
        ChangeNotifierProvider<FavouriteUsersData>(
          create: (_) => FavouriteUsersData(),
        ),
      ],
      child:MaterialApp(
      title: 'Welcome to Flutter',
      theme: themeData,
      home:SplashScreen(),
      ),
    ); 
  }
}
