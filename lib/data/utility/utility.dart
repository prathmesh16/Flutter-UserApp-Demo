import 'dart:convert';

import '../../features/common/models/user.dart';

//converting response data into json list
List<User> parseUsersList(String body){
  var response = json.decode(body);
  var data = response["data"] as List;
  return data.map<User>((json) => User.fromJson(json)).toList();
}