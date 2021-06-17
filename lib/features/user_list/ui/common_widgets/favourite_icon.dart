import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/features/user_list/data/models/user.dart';
import 'package:flutter_userapp_demo/features/favourite_user/data/favourite_users_data.dart';
import 'package:provider/provider.dart';

class FavouriteIcon extends StatelessWidget {
  final User user;

  FavouriteIcon({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(right: 0),
      child:Consumer<FavouriteUsersData>(builder: (context, favUsersData, child) {
          bool isPresent = favUsersData.isPresent(user.id);
          return IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              (isPresent)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              if (isPresent) {
                favUsersData.removeFromFavourites(user.id);
              } else {
                favUsersData.addToFavourites(user);
              }
            },
          );
        }
      ),
    );
  }
}
