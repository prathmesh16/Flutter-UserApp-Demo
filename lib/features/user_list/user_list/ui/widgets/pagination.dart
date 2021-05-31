import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  ScrollController sc;
  Pagination({this.sc});

  @override
  _PaginationState createState() => _PaginationState(scrollController: sc);
}

class _PaginationState extends State<Pagination> {
  int _pageNo = 1;
  ScrollController scrollController;
  _PaginationState({this.scrollController});

  _scrollListner() {
    if (this.mounted)
      setState(() {
        _pageNo = ((scrollController.position.pixels)) ~/ (20 * 130) + 1;
      });
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListner);
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        child: new Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: new BoxDecoration(color: Colors.grey[200]),
            child: new GestureDetector(
              child: Text('Current Page ${_pageNo}'),
              onTap: () {},
            )));
  }
}
