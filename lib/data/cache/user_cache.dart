import '../../features/common/models/user.dart';

class UserCache{
  
  //storage to cache users data
  var _userCache = <int, List<User>>{};

  void clearUserCache(){
    _userCache.clear();
  }

  void addToUserCache(List<User> userList,int pageNo)
  {
    _userCache[pageNo]=userList;
  } 

  bool isUserListPresent(int pageNo)
  {
    if(_userCache[pageNo]!=null){
      return true;
    }
    return false;  
  }

  List<User> getFromCache(int pageNo){
    if(_userCache[pageNo]!=null){
      return _userCache[pageNo];
    }
    return null;  
  }
  
}