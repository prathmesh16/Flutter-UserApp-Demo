import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_userapp_demo/main2.dart';
import 'package:flutter_userapp_demo/myWidgets/Pagination.dart';
import 'dart:convert';
import './models/User.dart';
import './myWidgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './myWidgets/PopUpDialogAddUser.dart';
import './myWidgets/PopUpDialogFilters.dart';

void main() => runApp(MaterialApp(home:MyApp()));

//converting response data into json list
List<User> parseUsersList(String body){
  var response = json.decode(body);
  var data = response["data"] as List;
  return data.map<User>((json) => User.fromJson(json)).toList();
}



//Application Q
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>_MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<_MainScreenState> _mainScreenState = GlobalKey<_MainScreenState>();
  void applyFilters(HashMap<String,String> newFIlters)
  {
    _mainScreenState.currentState.applyFilters(newFIlters);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User App'),
          actions: [
            new IconButton(
                  icon: Icon(Icons.autorenew_sharp,size: 30,),
                  onPressed: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp2()));
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
                        filters: _mainScreenState.currentState.filters
                      ),
                    );
                  }
                ),
                //  Positioned(
                //   top: 0,
                //   right: 0,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //     decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                //     alignment: Alignment.center,
                //     child: Text('0'),
                //   ),
                // )
              ],
            )
            
          ],
        ),
        body: MainScreen(key:_mainScreenState),
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

//MainScreen (Scroll View with paging and users data)
class MainScreen extends StatefulWidget{

  MainScreen({Key key}) : super(key:key);   
  @override
  _MainScreenState createState() =>_MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
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


  //GET request to fetch users list
  Future <void> fetchUserList(HashMap<String,String> filters) async{
    String str="&&";
    int i=0;
    
    filters.forEach((key, value) {
      if(i>0)
      {
        str+="&&";
      }
      str += key+"="+value;
      i++;
    });
    try {
      final http.Response response = await http.get("https://gorest.co.in/public-api/users?page=${_pageNo}${(str.length>2)?str:''}");
      List<User> fetchedUsers =  parseUsersList(response.body);
      setState(() {
          _hasMore = fetchedUsers.length == _defaultUsersPerPageCount;
          _loading = false;
          _pageNo = _pageNo + 1;
          _users.addAll(fetchedUsers);
          //Toast.show('${_pageNo}', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
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
  //  _scrollListner(){
  //     // setState(() {
  //     //     _p=(( (_scrollController.position.pixels))/(_defaultUsersPerPageCount*130)).toInt()+1;
  //     // });
  //  }

  @override
  void initState() {
    super.initState();

    // initial load
    _hasMore = true;
    _error = false;
    _loading = true;
    _pageNo = 1;
    _users = [];
    fetchUserList(filters);
    _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListner);
  }
  void changePage(int page)
  {
    for(int i=_pageNo;i<=page;i++)
    {
      fetchUserList(filters);
    }
    _scrollController.jumpTo((page*130*_defaultUsersPerPageCount).toDouble());
  }

void refreshPage(){
  setState(() {
    _users.clear();
    _hasMore = true;
    _error = false;
    _loading = true;
    _pageNo=1;
  });
  fetchUserList(filters);
}

   void applyFilters(HashMap<String,String> newFilters)
   {
    setState(() {
      filters = newFilters;
      refreshPage();
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
                fetchUserList(filters);
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
                          fetchUserList(filters);
                        }
                          if (index == _users.length) {
                            if (_error) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = true;
                                    _error = false;
                                    fetchUserList(filters);
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
                                  refreshPage();
                                }
                        }),
                      );
                    }
                   ),
                   onRefresh: ()async{ refreshPage();},
                   ),
                 ),
                 Pagination(sc:_scrollController) 
            ],
          );
        }
        return Container();
  }
  
}