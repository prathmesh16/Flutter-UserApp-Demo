import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/features/common/models/user.dart';
import 'package:flutter_userapp_demo/features/common/widgets/blank_slate.dart';
import 'package:flutter_userapp_demo/features/common/widgets/user_card.dart';
import 'package:flutter_userapp_demo/features/favourite_user/state/favourite_users_data.dart';
import 'package:provider/provider.dart';

class FavouriteUserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Users"),
      ),
      body: FavouriteUserList(),
    );
  }
}

class FavouriteUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favUsers = Provider.of<FavouriteUsersData>(context);
    List<User> favUsersData = favUsers.getFavUsers();
    if (favUsersData.isEmpty) {
      return BlankSlate(
        message: 'No favourites found',
        callback: () {},
      );
    }
    return ListView.builder(
        itemCount: favUsersData.length,
        itemBuilder: (context, index) {
          return Container(
            key: UniqueKey(),
            child: new UserCard(
                user: favUsersData[index], callback: null, isFavUserCard: true),
          );
        });
  }
}
