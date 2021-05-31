import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/data/cache/user_cache.dart';
import 'package:flutter_userapp_demo/features/common/widgets/blank_slate.dart';
import 'package:flutter_userapp_demo/features/common/widgets/network_error.dart';
import 'package:flutter_userapp_demo/features/favourite_user/state/favourite_users_data.dart';
import 'package:flutter_userapp_demo/features/favourite_user/ui/favourite_user_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../../data/repository/user_repository.dart';
import './widgets/pagination.dart';
import '../../../common/models/user.dart';
import '../../../common/widgets/user_card.dart';
import '../../../common/widgets/pop_up_dialog_add_user.dart';
import '../../../common/widgets/pop_up_dialog_filters.dart';
import '../models/paging_helper.dart';

//Paginated ListView Screen
class PaginatedUserListScreen extends StatefulWidget {
  @override
  _PaginatedUserListScreenState createState() =>
      _PaginatedUserListScreenState();
}

class _PaginatedUserListScreenState extends State<PaginatedUserListScreen> {
  final GlobalKey<_PaginatedUserListState> _paginatedListViewState =
      GlobalKey<_PaginatedUserListState>();
  void applyFilters(HashMap<String, String> newFIlters) {
    _paginatedListViewState.currentState._applyFilters(newFIlters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User App'),
        actions: [
          new IconButton(
              icon: Icon(
                Icons.favorite_rounded,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavouriteUserListScreen()));
              }),
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.filter_alt_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => PopUpDialogFilters(
                          context: context,
                          callback: applyFilters,
                          filters:
                              _paginatedListViewState.currentState.filters),
                    );
                  }),
            ],
          )
        ],
      ),
      body: PaginatedListView(key: _paginatedListViewState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                PopUpDialogAddUser(context: context),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

//Paginated ListView (Scroll View with paging and users data)
class PaginatedListView extends StatefulWidget {
  PaginatedListView({Key key}) : super(key: key);
  @override
  _PaginatedUserListState createState() => _PaginatedUserListState();
}

class _PaginatedUserListState extends State<PaginatedListView> {
  PagingHelper _pagingHelper = new PagingHelper(pageNo: 1, totalPages: 0);

  UserRepository userRepository = new UserRepository();

  Future<List<User>> _futureUserList;
  HashMap<String, String> filters = new HashMap<String, String>();

  //Fetch paginated users list from API Service
  Future<List<User>> _fetchUserList(
      {HashMap<String, String> filters, bool clearCache = false}) async {
    return await userRepository.fetchPaginatedUserList(
        filters, _pagingHelper, _refreshPage, clearCache);
  }

  @override
  void initState() {
    super.initState();

    // initial load
    _pagingHelper.pageNo = 1;
    _futureUserList = _fetchUserList(filters: filters);
  }

  void _nextPage() {
    setState(() {
      if (_pagingHelper.pageNo < _pagingHelper.totalPages)
        _pagingHelper.pageNo += 1;
      _futureUserList = _fetchUserList(filters: filters);
    });
  }

  void _previousPage() {
    setState(() {
      if (_pagingHelper.pageNo > 1) {
        _pagingHelper.pageNo -= 1;
        _futureUserList = _fetchUserList(filters: filters);
      }
    });
  }

  void _changePage(int page) {
    setState(() {
      _pagingHelper.pageNo = page;
      _futureUserList = _fetchUserList(filters: filters);
    });
  }

  void _refreshPage() {
    setState(() {
      _futureUserList = _fetchUserList(filters: filters);
    });
  }

  void _applyFilters(HashMap<String, String> newFilters) {
    setState(() {
      filters = newFilters;
      _futureUserList = _fetchUserList(filters: filters, clearCache: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<User>>(
      future: _futureUserList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<User> _users = snapshot.data;
            if (_users.isEmpty) {
              return BlankSlate(
                message: 'No users found',
                callback: _refreshPage,
              );
            }
            return RefreshIndicator(
              child: ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: <Widget>[
                  //Paging Row implementation
                  Pagination(
                    totalPages: _pagingHelper.totalPages,
                    pageNo: _pagingHelper.pageNo,
                    callbackChangePage: _changePage,
                    callbackNextPage: _nextPage,
                    callbackPreviousPage: _previousPage,
                  ),
                  //ListView of users data
                  Container(
                    color: Colors.grey[200],
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        key: UniqueKey(),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          return UserCard(
                              user: _users[index],
                              callback: (val) {
                                if (val == null) {
                                  if (Provider.of<FavouriteUsersData>(context,
                                          listen: false)
                                      .isPresent(_users[index].id))
                                    Provider.of<FavouriteUsersData>(context,
                                            listen: false)
                                        .removeFromFavourites(_users[index].id);
                                  print("inside delete");
                                  setState(() {
                                    _users.removeAt(index);
                                  });

                                  return;
                                }
                                bool flag = true;

                                if (!filters.containsValue(val.gender) &&
                                    !filters.containsValue(val.status))
                                  flag = false;

                                if (filters.length == 0 || flag) {
                                  _futureUserList.then((value) => {
                                        for (int i = 0; i < value.length; i++)
                                          {
                                            if (value[i].id == val.id)
                                              {value[i] = val}
                                          },
                                        _futureUserList =
                                            Future<List<User>>.value(value),
                                        if (Provider.of<FavouriteUsersData>(
                                                context,
                                                listen: false)
                                            .isPresent(val.id))
                                          Provider.of<FavouriteUsersData>(
                                                  context,
                                                  listen: false)
                                              .editFavourites(val)
                                      });
                                } else {
                                  setState(() {
                                    _futureUserList =
                                        _fetchUserList(filters: filters);
                                  });
                                }
                              });
                        }),
                  ),
                ],
              ),
              onRefresh: () async {
                _refreshPage();
              },
            );
          } else if (snapshot.hasError) {
            return NetworkError(
              message: "${snapshot.error}",
              callback: _refreshPage,
            );
          }
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
