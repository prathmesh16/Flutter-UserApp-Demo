import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  _PaginatedUserListScreenState createState() =>_PaginatedUserListScreenState();
}

class _PaginatedUserListScreenState extends State<PaginatedUserListScreen> {

  final GlobalKey<_PaginatedUserListState> _paginatedListViewState = GlobalKey<_PaginatedUserListState>();
  void applyFilters(HashMap<String,String> newFIlters)
  {
    _paginatedListViewState.currentState._applyFilters(newFIlters);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User App'),
          actions: [
            new Stack(
              children:<Widget> [
                new IconButton(
                  icon: Icon(Icons.filter_alt_sharp,size: 30,),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => PopUpDialogFilters(
                        context:context,
                        callback:applyFilters,
                        filters: _paginatedListViewState.currentState.filters
                      ),
                    );
                  }
                ),
              ],
            )
            
          ],
        ),
        body: PaginatedListView(key:_paginatedListViewState),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) => PopUpDialogAddUser(context:context),
             );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ), 
      ),
    );
  }
}

//Paginated ListView (Scroll View with paging and users data)
class PaginatedListView extends StatefulWidget{

  PaginatedListView({Key key}) : super(key:key);   
  @override
  _PaginatedUserListState createState() =>_PaginatedUserListState();
}

class _PaginatedUserListState extends State<PaginatedListView>{

  PagingHelper _pagingHelper = new PagingHelper(pageNo: 1,totalPages: 0);

  UserRepository userRepository = new UserRepository();

  Future<List<User>> _futureUserList ;
  HashMap<String,String> filters = new HashMap<String, String>();

  //storage to cache users data
  var cachedUserList = <int, Future<List<User>>>{};

  //Fetch paginated users list from API Service
  Future<List<User>> _fetchUserList(HashMap<String,String> filters) async{
    return await userRepository.fetchPaginatedUserList(filters, _pagingHelper, _refreshPage);
  }
  
  @override
  void initState() {
    super.initState();

    // initial load
    _pagingHelper.pageNo = 1;
    _futureUserList = _fetchUserList(filters);
    cachedUserList[_pagingHelper.pageNo]=_futureUserList;
  }

  void _nextPage(){
    setState(() {
      if(_pagingHelper.pageNo<_pagingHelper.totalPages)
        _pagingHelper.pageNo+=1;
      if(cachedUserList[_pagingHelper.pageNo]!=null)
      {
        _futureUserList=cachedUserList[_pagingHelper.pageNo];
      }
      else
      {
        _futureUserList =_fetchUserList(filters);
        cachedUserList[_pagingHelper.pageNo]=_futureUserList;
      }
    });
  }
  
  void _previousPage()
  {
    setState(() {
      if(_pagingHelper.pageNo>1)
      {
        _pagingHelper.pageNo-=1;
        if(cachedUserList[_pagingHelper.pageNo]!=null)
        {
          _futureUserList=cachedUserList[_pagingHelper.pageNo];
        }
        else
        {
          _futureUserList =_fetchUserList(filters);
          cachedUserList[_pagingHelper.pageNo]=_futureUserList;
        }
      }
    });
  }

  void _changePage(int page)
  {
     setState(() {
      _pagingHelper.pageNo=page;
      if(cachedUserList[_pagingHelper.pageNo]!=null)
      {
        _futureUserList=cachedUserList[_pagingHelper.pageNo];
      }
      else
      {
        _futureUserList =_fetchUserList(filters);
        cachedUserList[_pagingHelper.pageNo]=_futureUserList;
      }
    });
  }

  void _refreshPage(){
    setState(() {
        _futureUserList =_fetchUserList(filters);
        cachedUserList[_pagingHelper.pageNo]=_futureUserList;
    });
  }

  void _applyFilters(HashMap<String,String> newFilters)
  {
    setState(() {
      filters = newFilters;
      cachedUserList.clear();
      _futureUserList = _fetchUserList(filters);
      cachedUserList[_pagingHelper.pageNo] = _futureUserList;
    }); 
  }

  @override
  Widget build(BuildContext context)
  {
    return new FutureBuilder<List<User>>(
          future: _futureUserList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data;
                return RefreshIndicator( 
                  child:ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      //Paging Row implementation
                      Pagination(
                        totalPages: _pagingHelper.totalPages,
                        pageNo: _pagingHelper.pageNo,
                        callbackChangePage:_changePage ,
                        callbackNextPage: _nextPage,
                        callbackPreviousPage: _previousPage,
                      ),
                      //ListView of users data
                      Container(
                        color: Colors.grey[200],
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          key: UniqueKey(),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder:(context,index){
                            return UserCard(context:context,user:users[index],callback:(val){
                              if(val==null)
                              {
                                print("inside delete");                                
                                setState(() {
                                  users.removeAt(index);
                                });
                                
                                return ;
                              }

                              bool flag= true;

                              if(!filters.containsValue(val.gender) && !filters.containsValue(val.status))
                                flag = false;

                              if(filters.length==0 || flag)
                              {
                                cachedUserList[_pagingHelper.pageNo].then((value) => {
                                  for(int i=0;i<value.length;i++)
                                  {
                                    if(value[i].id==val.id)
                                    {
                                      value[i]=val
                                    }
                                  },
                                  cachedUserList[_pagingHelper.pageNo] = Future<List<User>>.value(value)
                                });
                              }
                              else
                              {
                                setState(() {
                                  _futureUserList = _fetchUserList(filters);
                                  cachedUserList[_pagingHelper.pageNo] = _futureUserList;
                                });
                              }
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  onRefresh:()async{ _refreshPage();},
                );
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget> [
                        Image.asset("assets/network_error.png"),
                        Text("${snapshot.error}"),
                        TextButton(
                          onPressed: _refreshPage,
                          child:Text("Try again" ,style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                  );
                }
            }
            // By default, show a loading spinner.
            return Center(child:CircularProgressIndicator());
          },
        );
  }
}