import 'package:flutter/material.dart';

class ButtonLogin extends MaterialButton {
  ButtonLogin({
    this.isError=false,
    this.backgroundColor = Colors.transparent,
    this.label = 'OK',
    this.labelColor = Colors.white,
    this.mOnPressed,
    this.isLoading = false,
    this.height,
    this.minWidth,
  });
  final isError;
  final minWidth;
  final height;
  final bool isLoading;
  final Color backgroundColor;
  final String label;
  final Color labelColor;
  final VoidCallback mOnPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
        (isError)?
        Container(height:25,child: Text("Incorrect Credentials!",style: TextStyle(color: Colors.red),)):
        SizedBox(height: 25,),
        Container(
        height: 50,
        width: 250,
        margin: EdgeInsets.only(top:30),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)
          ),
        child:ElevatedButton(
          style: ButtonStyle(
            shape:MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              )
            )
          ),
          child: isLoading
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right:10),
                        child: Text(
                          label,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: labelColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.centerRight,
                        child: CircularProgressIndicator(strokeWidth: 2,valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)
                      )
                    ],
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: labelColor,
                      fontWeight: FontWeight.bold),
                ),
          onPressed: mOnPressed,
        ),
      ),
      ]
    );
  }
}