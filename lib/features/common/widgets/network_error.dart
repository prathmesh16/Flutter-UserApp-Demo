import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkError extends StatelessWidget {
  final String message;
  final callback;
  NetworkError({this.message, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/network_error.png"),
          Text(message),
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
