import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../models/User.dart';
import 'PopUpDialogEditUser.dart';

import 'package:http/http.dart' as http;

Future<void> deleteUser(BuildContext context,int id)async{
  final http.Response response = await http.delete("https://gorest.co.in/public-api/users/${id}",
  headers: <String, String>{
        'Authorization':'Bearer 75d4b33b09d291e83932a38ff386a1eeee39b813d355d88bc09a30dd9f9489ef'
      },
  );

  var res = json.decode(response.body);
  if(res["code"]==204)
  {
    Toast.show("User deleted!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }
  else
  {
    Toast.show(res["data"]["message"], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }
}


class UserCard extends StatefulWidget{
  User user;
  BuildContext context;
  var callback;

  UserCard({this.context,this.user,this.callback});
  @override
  _MyUserCard createState() => _MyUserCard(homeContext:context,user: user,callback:callback);
}
class _MyUserCard extends State<UserCard>
{
  BuildContext homeContext;
  User user;
  var callback;
  _MyUserCard({this.homeContext,this.user,this.callback});
  
  String limitName(String name)
  {
      if(name.length>23)
        return name.substring(0,23)+"...";
      return name;  
  }

  String limitEmail(String email)
  {
      if(email.length>35)
        return email.substring(0,35)+"...";
      return email;  
  }
 
  Widget dropDownOptions()
  {
    return new PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert,color: Colors.grey[500],),
      onSelected: (String ch){
        if(ch=="Edit")
        {
          showDialog(
            context: homeContext,
            builder: (BuildContext context) => PopUpDialog(context:context,user: user,callback: (updatedUser){
              setState((){
                user=updatedUser;
                callback(updatedUser);
              });
            }),
          );
        }
        if(ch=="Delete")
        {
          deleteUser(context, user.id).then((value) => {
            callback(null)
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
                value: 'Edit',
                child: ListTile(
                  leading: Icon(Icons.edit), title: Text('Edit User'),
                )
              ),
            const PopupMenuItem<String>(
                value: 'Delete',
                child: ListTile(
                  leading: Icon(Icons.delete), title: Text('Delete User')))
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 5),
              blurRadius: 3.0,
              spreadRadius: 1.0,
            ),
          ],
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.grey[300],
        //   width: 1,
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:30),
                child: Text(
                  limitName('${user.name}'),
                  style: TextStyle(fontSize: 20),
                )
              ),    
              Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.info_outline,color: Colors.grey[500]),
                    alignment: Alignment.centerRight,
                  ),
                  dropDownOptions(),
                ],
              ),    
            ],
          ),
          Container(
            margin: EdgeInsets.only(left:30),
            alignment: AlignmentDirectional.centerStart,
            child: Text(limitEmail('${user.email}'))
            ),
          Container(
            margin: EdgeInsets.only(top:10,left: 30,right:30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${user.gender}'),
                Row(
                  children: [
                    Text('${user.status}'),
                    Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                        color:(user.status=="Active")?Colors.green:Colors.red,
                        borderRadius: BorderRadius.circular(5) 
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}