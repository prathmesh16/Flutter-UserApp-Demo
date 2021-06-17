import 'package:flutter/cupertino.dart';
import 'package:flutter_userapp_demo/features/user_list/data/models/user.dart';

class FavouriteUsersData extends ChangeNotifier {
  Map<int, User> _favUsers = {};
  bool isPresent(int id) {
    return _favUsers.containsKey(id);
  }

  void addToFavourites(User user) {
    _favUsers[user.id] = user;
    notifyListeners();
  }

  void editFavourites(User user) {
    _favUsers[user.id] = user;
    notifyListeners();
  }

  void removeFromFavourites(int id) {
    _favUsers.remove(id);
    notifyListeners();
  }

  List<User> getFavUsers() {
    return _favUsers.entries.map((e) => e.value).toList();
  }

  void clearFavourites() {
    _favUsers.clear();
    notifyListeners();
  }
}
