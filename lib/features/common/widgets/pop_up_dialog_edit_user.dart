import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../../data/network/user_api_service.dart';
import '../../common/models/user.dart';


class PopUpDialogEditUser extends StatefulWidget{
  BuildContext context;
  User user;

  var callback;
  
  PopUpDialogEditUser({this.context,this.user,this.callback});
  
  @override
  _PopUpDialogEditUserState createState() => _PopUpDialogEditUserState(context:context,user: user,callback:callback);
}

class _PopUpDialogEditUserState extends State<PopUpDialogEditUser>{
  User user;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isActive = false;
  String dropdownValue = 'Gender';
  BuildContext context;
  var callback ;

  _PopUpDialogEditUserState({this.context,this.user,this.callback});
 
  @override
  void initState() {
    super.initState();
    nameController.text = user.name;
    emailController.text = user.email;
    _isActive = (user.status=="Active")?true:false;
    dropdownValue = user.gender;
  }

  void _updateUser(){
    
    User updatedUser = new User(
        id:user.id,
        name:(nameController.text)??"",
        email:emailController.text??"",
        status: (_isActive)?"Active":"Inactive",
        gender: dropdownValue
      );

      UserApiService.updateUserRequest(updatedUser, (message,user)=>{
        if(user!=null)
          callback(user),
        Toast.show(message??"", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER),
        Navigator.of(context).pop()  
      });
  }

  @override
  Widget build(BuildContext context) {
      return new AlertDialog(
      title: const Text('Edit User'),
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
            _updateUser();
             },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Save'),
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