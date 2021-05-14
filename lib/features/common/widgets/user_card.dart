import 'package:flutter/material.dart';

import 'package:toast/toast.dart';


import '../../../data/repository/user_repository.dart';
import '../../common/models/user.dart';
import './pop_up_dialog_edit_user.dart';



class UserCard extends StatefulWidget{
  User user;
  BuildContext context;
  var callback;

  UserCard({this.context,this.user,this.callback});

  @override
  _UserCardState createState() => _UserCardState(homeContext:context,user: user,callback:callback);
}
class _UserCardState extends State<UserCard>
{
  BuildContext homeContext;
  User user;
  var callback;
  
  UserRepository userRepository = new UserRepository();

  _UserCardState({this.homeContext,this.user,this.callback});
  
  //Deletes user using API Service
  Future<void> _deleteUser(BuildContext context,int id)async{
    await userRepository.deleteUserRequest(id).then((message) => { 
      Toast.show(message, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM)
    });
  }

  String _limitName(String name)
  {
      if(name.length>23)
        return name.substring(0,23)+"...";
      return name;  
  }

  String _limitEmail(String email)
  {
      if(email.length>35)
        return email.substring(0,35)+"...";
      return email;  
  }
 
  Widget _dropDownOptions()
  {
    return new PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert,color: Colors.grey[500],),
      onSelected: (String choice){
        if(choice=="Edit")
        {
          showDialog(
            context: homeContext,
            builder: (BuildContext context) => PopUpDialogEditUser(context:context,user: user,callback: (updatedUser){
              setState((){
                user=updatedUser;
                callback(updatedUser);
              });
            }),
          );
        }
        if(choice=="Delete")
        {
          _deleteUser(context, user.id).then((value) => {
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
                  _limitName('${user.name}'),
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
                  _dropDownOptions(),
                ],
              ),    
            ],
          ),
          Container(
            margin: EdgeInsets.only(left:30),
            alignment: AlignmentDirectional.centerStart,
            child: Text(_limitEmail('${user.email}'))
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