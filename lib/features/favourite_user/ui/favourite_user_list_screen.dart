import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/features/user_list/data/models/user.dart';
import 'package:flutter_userapp_demo/features/user_list/ui/common_widgets/blank_slate.dart';
import 'package:flutter_userapp_demo/features/user_list/ui/common_widgets/user_card.dart';
import 'package:flutter_userapp_demo/features/favourite_user/data/favourite_users_data.dart';
import 'package:provider/provider.dart';


class FavouriteUserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Users"),
        actions: [
          new IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed:(){
              showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Do you really want to clear Favourites?'),
                  actions: [
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () =>{
                        Provider.of<FavouriteUsersData>(context,listen: false).clearFavourites(),
                        Navigator.pop(c, false),
                      }
                    ),
                    TextButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(c, false),
                    ),
                  ],
                ),
              );
            },
          )
        ],
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
