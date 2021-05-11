import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/screens/lazy_list_view_screen.dart';

void main() => runApp(Application());

//Application
class Application extends StatefulWidget {
  @override
  _ApplicationState createState() =>_ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: LazyListViewScreen(), 
    );
  }
}