import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../../data/repository/user_repository.dart';
import '../models/user.dart';

class PopUpDialogAddUser extends StatefulWidget{
  final BuildContext context;

  PopUpDialogAddUser({this.context});
  
  @override
  _PopUpDialogAddUserState createState() => _PopUpDialogAddUserState(context:context);
}

class _PopUpDialogAddUserState extends State<PopUpDialogAddUser>{

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool _isActive = false;
  String dropdownValue = 'Gender';
  BuildContext context;

  UserRepository userRepository = new UserRepository();

  _PopUpDialogAddUserState({this.context});
  
  @override
  void initState() {
    super.initState();
  }

  void _addUser(){
    User user = new User(
        name:nameController.text,
        email:emailController.text,
        status: (_isActive)?"Active":"Inactive",
        gender: dropdownValue
      );

      userRepository.addUserRequest(user).then((message) => {
        Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER),
        if(message=="User added!")
          Navigator.of(context).pop()
      });
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
            _addUser();
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