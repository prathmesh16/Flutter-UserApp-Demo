import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository {
  Future<bool> authenticateUser(String email, String password) async{
    if(email == "pkj@gmail.com" && password == "pkj") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);
      prefs.setString("password",password);
      return true;
    }
    return false;  
  }
  void logoutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  Future<bool> checkUserPrefrences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email");
    String password = prefs.getString("password");
    if(email != "" && password != "") {
      return authenticateUser(email, password);
    }
    return false;
  }
}