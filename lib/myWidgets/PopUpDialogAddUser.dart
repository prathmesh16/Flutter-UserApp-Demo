import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';

Future<void> addUserRequest(User user,BuildContext context) async {
    final http.Response response = await http.post("https://gorest.co.in/public-api/users",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer 75d4b33b09d291e83932a38ff386a1eeee39b813d355d88bc09a30dd9f9489ef'
      },
      body: jsonEncode(<String, String>{
        "name":user.name,
        "email":user.email,
        "status":user.status,
        "gender":user.gender
      }),
    );
    var tmp = json.decode(response.body);
    if(tmp["code"]==201)
    {
      Toast.show("User added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      Navigator.of(context).pop();
    }
    else
    {
      try{
        Toast.show(tmp["data"][0]["field"]+" "+tmp["data"][0]["message"], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
      catch(e){
        Toast.show("Something went wrong please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
    }
}

class PopUpDialogAddUser extends StatefulWidget{
  final BuildContext context;

  PopUpDialogAddUser({this.context});
  
  @override
  _MyPopUpDialogAddUser createState() => _MyPopUpDialogAddUser(context:context);
}

class _MyPopUpDialogAddUser extends State<PopUpDialogAddUser>{
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isActive = false;
  String dropdownValue = 'Gender';
  BuildContext context;

  _MyPopUpDialogAddUser({this.context});
  
  @override
  void initState() {
    super.initState();
  }

  void addUser()async{
    User user = new User(
        name:nameController.text,
        email:emailController.text,
        status: (_isActive)?"Active":"Inactive",
        gender: dropdownValue
      );
      addUserRequest(user, context);
  }

  @override
  Widget build(BuildContext context) {
      return new AlertDialog(
      title: const Text('Add New User'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          SizedBox(height:10),
          Row(
            children: <Widget>[
              Switch(
                value: _isActive,
                onChanged: (value){
                  setState(() {
                    _isActive=value;
                  });
                },
                activeTrackColor: Colors.lightBlue,
                activeColor: Colors.lightBlueAccent,
                ),
                SizedBox(width:10),
                Text((_isActive)?"Active":"Inactive"),
            ],
          ),
          Container(
            margin:EdgeInsets.only(left:20),
            child: DropdownButton<String>(
              value: dropdownValue,
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.blue),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['Gender', 'Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed : (){
            addUser();
             },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Add'),
        ),
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }


}