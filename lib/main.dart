import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_userapp_demo/models/user.dart';
import 'package:flutter_userapp_demo/main2.dart';
import 'package:flutter_userapp_demo/custom_widgets/Pagination.dart';
import 'package:flutter_userapp_demo/custom_widgets/user_card.dart';
import 'package:flutter_userapp_demo/custom_widgets/pop_up_dialog_add_user.dart';
import 'package:flutter_userapp_demo/custom_widgets/pop_up_dialog_filters.dart';
import 'package:flutter_userapp_demo/constants/constants.dart';
import 'package:flutter_userapp_demo/utility/utility.dart';

void main() => runApp(MaterialApp(home:Application()));

//Application
class Application extends StatefulWidget {
  @override
  _ApplicationState createState() =>_ApplicationState();
}

class _ApplicationState extends State<Application> {

  final GlobalKey<_HomePageState> _mainScreenState = GlobalKey<_HomePageState>();
  void applyFilters(HashMap<String,String> newFIlters)
  {
    _mainScreenState.currentState._applyFilters(newFIlters);
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
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Application2()));
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
              ],
            )
            
          ],
        ),
        body: HomePage(key:_mainScreenState),
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
class HomePage extends StatefulWidget{

  HomePage({Key key}) : super(key:key);   
  @override
  _HomePageState createState() =>_HomePageState();
}
class _HomePageState extends State<HomePage>{
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
  Future <void> _fetchUserList(HashMap<String,String> filters) async{
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
      final http.Response response = await http.get("${Constants.userFetchURL}?page=${_pageNo}${(str.length>2)?str:''}");
      List<User> fetchedUsers =  parseUsersList(response.body);
      setState(() {
          _hasMore = fetchedUsers.length == _defaultUsersPerPageCount;
          _loading = false;
          _pageNo = _pageNo + 1;
          _users.addAll(fetchedUsers);
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
    _fetchUserList(filters);
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
    _fetchUserList(filters);
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
                _fetchUserList(filters);
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
                          _fetchUserList(filters);
                        }
                          if (index == _users.length) {
                            if (_error) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = true;
                                    _error = false;
                                    _fetchUserList(filters);
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