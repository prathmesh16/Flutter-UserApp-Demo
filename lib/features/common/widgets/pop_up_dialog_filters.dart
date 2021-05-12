import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopUpDialogFilters extends StatefulWidget
{
  final BuildContext context;
  var callback;
  HashMap<String,String> filters;

  PopUpDialogFilters({this.context,this.callback,this.filters});

  @override
  _PopUpDialogFiltersState createState() => _PopUpDialogFiltersState(context: context,callback:callback,filters:filters);
}

class _PopUpDialogFiltersState extends State<PopUpDialogFilters>
{
  final BuildContext context;
  HashMap<String,String> filters;
  HashMap<String,String> cpyFilters = new HashMap<String,String>();
  var callback;

_PopUpDialogFiltersState({this.context,this.callback,this.filters});

  String _genderFilter = "None";
  String _statusFilter = "None";
  
  @override
  void initState() {
    super.initState();

    filters.forEach((key, value) {
      if(key == "status")
        _statusFilter=value;
      if(key == "gender")
        _genderFilter=value;  
      cpyFilters[key]=value;
    });
  }

  void _handleGenderFilter(String value)
  {
    if(value == "None")
    {
      filters.remove("gender");
    }
    else
    {
      filters["gender"]=value;
    }
    setState(() {
      _genderFilter = value;
    });
  }
  
  void _handleStatusFilter(String value)
  {
    if(value == "None")
    {
      filters.remove("status");
    }
    else
    {
      filters["status"]=value;
    }
    setState(() {
      _statusFilter = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
     title: const Text("Filters"),
     content: 
     Container(
       width: MediaQuery.of(context).size.width,
       child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             const Divider(
             height: 40,
             thickness: 1, 
             indent: 20,
             endIndent: 20,
            ),
            Text("Gender"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  backgroundColor: Colors.grey[300],
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(FontAwesomeIcons.mars)
                  ),
                  label: Text("Male"),
                  selected: filters.containsValue("Male"),
                  selectedColor: Colors.grey,
                  onSelected: (bool selected){
                      if(selected){
                        _handleGenderFilter("Male");
                      }
                      else
                      {
                        _handleGenderFilter("None");
                      }
                  }
                  ),
                  FilterChip(
                    backgroundColor: Colors.grey[300],
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(FontAwesomeIcons.venus)
                    ),
                    label: Text("Female"),
                    selected: filters.containsValue("Female"),
                    selectedColor: Colors.grey,
                    onSelected: (bool selected){
                      if(selected){
                        _handleGenderFilter("Female");
                      }
                      else
                      {
                        _handleGenderFilter("None");
                      }
                    }
                    ),
              ],
            ),
            const Divider(
             height: 40,
             thickness: 1, 
             indent: 20,
             endIndent: 20,
            ),
            Text("Status"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  backgroundColor: Colors.grey[300],
                  avatar: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text("A",style: TextStyle(color: Colors.white),),
                  ),
                  label: Text("Active"),
                  selected: filters.containsValue("Active"),
                  selectedColor: Colors.grey,
                  onSelected: (bool selected){
                      if(selected){
                        _handleStatusFilter("Active");
                      }
                      else
                      {
                        _handleStatusFilter("None");
                      }
                  }
                  ),
                  FilterChip(
                    backgroundColor: Colors.grey[300],
                    avatar: CircleAvatar(
                      backgroundColor: Colors.red[300],
                      child: Text("I",style: TextStyle(color: Colors.white),),
                    ),
                    label: Text("Inactive"),
                    selected: filters.containsValue("Inactive"),
                    selectedColor: Colors.grey,
                    onSelected: (bool selected){
                      if(selected){
                        _handleStatusFilter("Inactive");
                      }
                      else
                      {
                        _handleStatusFilter("None");
                      }
                    }
                    ),
              ],
            ),
            const Divider(
             height: 40,
             thickness: 1, 
             indent: 20,
             endIndent: 20,
            ),
          ],
       ),
     ),
     actions:<Widget> [
       new TextButton(
          onPressed : (){
              callback(filters);
              Navigator.of(context).pop();
            },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Apply'),
        ),
        new TextButton(
          onPressed : (){
              filters.clear();
              cpyFilters.forEach((key, value) {
                filters[key]=value;
              });
              Navigator.of(context).pop();
            },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Close'),
        ),
     ],
    ) ;
  }
} 