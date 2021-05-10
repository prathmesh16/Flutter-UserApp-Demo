import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';

Future<User> updateUserRequest(User user,BuildContext context) async {
    final http.Response response = await http.put("https://gorest.co.in/public-api/users/${user.id}",
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
    if(tmp["code"]==200)
    {
       try{
        Toast.show("User updated!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
         return User.fromJson(tmp["data"]);
      }
      catch(e){
        Toast.show("Something went wrong please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
        return null;
      }
     
    }
    else
    {
      try{
        Toast.show(tmp["data"][0]["field"]+" "+tmp["data"][0]["message"], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
      catch(e){
        Toast.show("Something went wrong please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
      return null;
    }
    
}

class PopUpDialog extends StatefulWidget{
  BuildContext context;
  User user;

  var callback;
  
  PopUpDialog({this.context,this.user,this.callback});
  
  @override
  _MyPopUpDialog createState() => _MyPopUpDialog(context:context,user: user,callback:callback);
}

class _MyPopUpDialog extends State<PopUpDialog>{
  User user;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool _isActive = false;
  String dropdownValue = 'Gender';
  BuildContext context;
  var callback ;

  _MyPopUpDialog({this.context,this.user,this.callback});
 
  @override
  void initState() {
    super.initState();
    nameController.text = user.name;
    emailController.text = user.email;
    _isActive = (user.status=="Active")?true:false;
    dropdownValue = user.gender;
  }

  void updateUser()async{
    User updatedUser = new User(
        id:user.id,
        name:(nameController.text)??"",
        email:emailController.text??"",
        status: (_isActive)?"Active":"Inactive",
        gender: dropdownValue
      );
      updateUserRequest(updatedUser, context).then((value) => { 
        if(value!=null) 
          callback(value),
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
            updateUser();
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