import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlankSlate extends StatelessWidget {
  final String message;
  final callback;
  BlankSlate({this.message, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/no_data.png',
          ),
          Text(
            message,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: callback,
            child: Text(
              "Try again",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
