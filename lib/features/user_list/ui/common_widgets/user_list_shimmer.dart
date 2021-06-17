import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserListShimmer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[400],
          highlightColor: Colors.grey[300],
          child:Container(
            margin: EdgeInsets.only(top:17,left: 25,right: 20,bottom: 20),
            height: 20,
            color: Colors.grey,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder:(context,index) {
            return UserListShimmerCard();
          }
        ),
      ],
    );
  }
}

class UserListShimmerCard extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[300],
        child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height:15,
              margin: EdgeInsets.only(left: 25,right:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 200,
                    color: Colors.grey,  
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        decoration: ShapeDecoration(
                          color: Colors.grey,
                          shape: CircleBorder()
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left:10),
                        width: 15,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 13,
              margin: EdgeInsets.only(left: 25,right: 7,top:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 30,
                      decoration: ShapeDecoration(
                        color: Colors.grey,
                        shape: CircleBorder()
                      ),
                    )
                ],
              ),
            ),
            Container(
              height: 12,
              margin: EdgeInsets.only(left: 25, right: 15,top:15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 50,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 45,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: EdgeInsets.only(left:5),
                        width: 10,
                         decoration: ShapeDecoration(
                          color: Colors.grey,
                          shape: CircleBorder()
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}