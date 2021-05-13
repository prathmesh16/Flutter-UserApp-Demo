import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../data/utility/utility.dart';
import '../../features/common/models/user.dart';
import '../../data/constants/api_constants.dart';
import '../../features/user_list/paginated_user_list/models/paging_helper.dart';

class APIService{

  //POST request to add user
  static Future<String> addUserRequest(User user) async {
    final http.Response response = await http.post(Constants.userAddURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${Constants.token}'
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
      return Future.value("User added!");
    }
    else
    {
      try{
        return Future.value(tmp["data"][0]["field"]+" "+tmp["data"][0]["message"]);
      }
      catch(e){
        return Future.value("Something went wrong please try again!");
      }
    }
  }

  //GET request to fetch users list
  static Future <List<User>> fetchUserList(HashMap<String,String> filters,int pageNo) async{
    String str="&&";
      int i=0;
      
      filters.forEach((key, value) {
        if(i>0)
        {
          str+="&&";
        }
        str += key+"="+value;
        i++;
      });

      final http.Response response = await http.get("${Constants.userFetchURL}?page=${pageNo}${(str.length>2)?str:''}");
      return compute(parseUsersList,response.body);
  }

  //GET request to fetch paginated users list
  static Future <List<User>> fetchPaginatedUserList(HashMap<String,String> filters,PagingHelper pagingHelper,var refreshPageCallback) async{
    String str="&&";
    int i=0;
    
    filters.forEach((key, value) {
      if(i>0)
      {
        str+="&&";
      }
      str += key+"="+value;
      i++;
    });

    try{
      final http.Response response = await http.get("${Constants.userFetchURL}?page=${pagingHelper.pageNo}${(str.length>2)?str:''}");
      
      var tmp =json.decode(response.body);
      pagingHelper.totalPages = tmp["meta"]["pagination"]["pages"];

      if(pagingHelper.totalPages<pagingHelper.pageNo)
      {
        pagingHelper.pageNo=pagingHelper.totalPages;
        refreshPageCallback();
      }
      
      return compute(parseUsersList,response.body);
    }catch(e) {
      print('error');
      return Future.error("Please check internet connection!");
    }
  }

  //PUT request to update user
  static Future<void> updateUserRequest(User user,var callback) async {
    final http.Response response = await http.put("${Constants.userEditURL}/${user.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'Bearer ${Constants.token}'
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
        callback("User updated!",User.fromJson(tmp["data"]));
      }
      catch(e){
        callback("Something went wrong please try again!",null);
      }  
    }
    else
    {
      try{
        callback(tmp["data"][0]["field"]+" "+tmp["data"][0]["message"],null);
      }
      catch(e){
        callback("Something went wrong please try again!",null);
      }
    }
  }

  //DELETE request to delete user
  static Future<String> deleteUserRequest(int id)async{

    final http.Response response = await http.delete("${Constants.userDeleteURL}/${id}",
    headers: <String, String>{
          'Authorization':'Bearer ${Constants.token}'
        },
    );

    var res = json.decode(response.body);
    if(res["code"]==204)
    {
      return Future.value("User deleted!");
    }
    else
    {
      return Future.value(res["data"]["message"]);
    }
  }

  
}