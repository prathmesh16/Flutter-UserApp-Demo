import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/features/favourite_user/state/favourite_users_data.dart';
import 'package:provider/provider.dart';

import './data/constants/app_theme.dart';
import './features/user_list/user_list/ui/user_list_screen.dart';

void main() => runApp(Application());

//Application
class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => new FavouriteUsersData(),
      child: MaterialApp(
          title: 'Welcome to Flutter',
          theme: themeData,
          home: UserListScreen()),
    );
  }
}
