import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/data/network/api_service.dart';

import '../../common/models/user.dart';
import '../../paginated_list_view/ui/paginated_list_view_screen.dart';
import 'widgets/pagination.dart';
import '../../common/widgets/user_card.dart';
import '../../common/widgets/pop_up_dialog_add_user.dart';
import '../../common/widgets/pop_up_dialog_filters.dart';

//Lazy ListView Sceen
class LazyListViewScreen extends StatefulWidget {
  @override
  _LazyListViewScreenState createState() =>_LazyListViewScreenState();
}

class _LazyListViewScreenState extends State<LazyListViewScreen> {

  final GlobalKey<_LazyListViewState> _lazyListViewState = GlobalKey<_LazyListViewState>();
  void applyFilters(HashMap<String,String> newFIlters)
  {
    _lazyListViewState.currentState._applyFilters(newFIlters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User App'),
          actions: [
            new IconButton(
                  icon: Icon(Icons.autorenew_sharp,size: 30,),
                  onPressed: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaginatedListViewScreen()));
                  }
                ),
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
                        filters: _lazyListViewState.currentState.filters
                      ),
                    );
                  }
                ),
              ],
            )
            
          ],
        ),
        body: LazyListView(key:_lazyListViewState),
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
      );
  }
}



//Lazy ListVIew (Scroll View with paging and users data)
class LazyListView extends StatefulWidget{

  LazyListView({Key key}) : super(key:key);   
  @override
  _LazyListViewState createState() =>_LazyListViewState();
}
class _LazyListViewState extends State<LazyListView>{
  int _pageNo;
  int totalPages ;
  bool _hasMore;
  bool _error;
  bool _loading;
  int _p =1;
  final int _defaultUsersPerPageCount = 20;
  List<User> _users;
  final int _nextPageThreshold = 2;
  HashMap<String,String> filters = new HashMap<String, String>();


  //Fetch user list from API Service
  Future <void> _fetchUserList(HashMap<String,String> filters,pageNo) async{
    try {
      APIService.fetchUserList(filters, pageNo).then((fetchedUsers) => {
        setState(() {
          _hasMore = fetchedUsers.length == _defaultUsersPerPageCount;
          _loading = false;
          _pageNo = _pageNo + 1;
          _users.addAll(fetchedUsers);
        })
      });
    }
    catch(e)
    {
        setState(() {
          _loading = false;
          _error = true;
        });
    }
  }

 ScrollController _scrollController ;

  @override
  void initState() {
    super.initState();

    // initial load
    _hasMore = true;
    _error = false;
    _loading = true;
    _pageNo = 1;
    _users = [];
    _fetchUserList(filters,_pageNo);
    _scrollController = ScrollController();
  }

  void _refreshPage(){
    setState(() {
      _users.clear();
      _hasMore = true;
      _error = false;
      _loading = true;
      _pageNo=1;
    });
    _fetchUserList(filters,_pageNo);
  }

   void _applyFilters(HashMap<String,String> newFilters)
   {
    setState(() {
      filters = newFilters;
      _refreshPage();
    });
   }
 
  @override
  Widget build(BuildContext context)
  {

      //ListView of users data
      if (_users.isEmpty) {
        if (_loading) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ));
        } else if (_error) {
          return Center(
              child: InkWell(
            onTap: () {
              setState(() {
                _loading = true;
                _error = false;
                _fetchUserList(filters,_pageNo);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Error while loading photos, tap to try agin"),
            ),
          ));
        }
      } else {
          return Stack(
            children: <Widget>[
                 Container(
                   color: Colors.grey[200],
                   margin: EdgeInsets.only(top:50),
                   child: RefreshIndicator(
                    child:ListView.builder( 
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _users.length + (_hasMore ? 1 : 0),
                    itemBuilder:(context,index){
                    
                        if (index == _users.length - _nextPageThreshold) {
                          _fetchUserList(filters,_pageNo);
                        }
                          if (index == _users.length) {
                            if (_error) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = true;
                                    _error = false;
                                    _fetchUserList(filters,_pageNo);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("Error while loading photos, tap to try agin"),
                                ),
                              ));
                            } else {
                              return Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ));
                            }
                          }
                      return Container(
                        key: UniqueKey(),
                        child: new UserCard(context:context,user:_users[index],callback:(val){ 
                          if(val==null)
                          {
                            print("inside delete");                                
                            setState(() {
                              _users.removeAt(index);
                            });
                            return ;
                          }
                          bool flag= true;
                          if(!filters.containsValue(val.gender) && !filters.containsValue(val.status))
                            flag = false;
                          if(filters.length==0 || flag)
                          {
                            for(int i=0;i<_users.length;i++)
                            {
                              if(_users[i].id==val.id)
                              {
                                _users[i]=val;
                              }
                            }
                          }
                          else
                          {
                            _refreshPage();
                          }
                        }),
                      );
                    }
                   ),
                   onRefresh: ()async{ _refreshPage();},
                   ),
                 ),
                 Pagination(sc:_scrollController) 
            ],
          );
        }
        return Container();
  }
  
}