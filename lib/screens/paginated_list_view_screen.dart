import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_userapp_demo/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_userapp_demo/models/user.dart';
import 'package:flutter_userapp_demo/custom_widgets/user_card.dart';
import 'package:flutter_userapp_demo/custom_widgets/pop_up_dialog_add_user.dart';
import 'package:flutter_userapp_demo/custom_widgets/pop_up_dialog_filters.dart';
import 'package:flutter_userapp_demo/utility/utility.dart';

//Paginated ListView Screen
class PaginatedListViewScreen extends StatefulWidget {
  @override
  _PaginatedListViewScreenState createState() =>_PaginatedListViewScreenState();
}

class _PaginatedListViewScreenState extends State<PaginatedListViewScreen> {

  final GlobalKey<_PaginatedListViewState> _paginatedListViewState = GlobalKey<_PaginatedListViewState>();
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
  _PaginatedListViewState createState() =>_PaginatedListViewState();
}
class _PaginatedListViewState extends State<PaginatedListView>{

  int pageNo;
  int totalPages ;
  Future<List<User>> _futureUserList ;
  HashMap<String,String> filters = new HashMap<String, String>();

  //storage to cache users data
  var cachedUserList = <int, Future<List<User>>>{};

  //GET request to fetch users list
  Future < List<User>> _fetchUserList(HashMap<String,String> filters,int page) async{
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

    final http.Response response = await http.get("${Constants.userFetchURL}?page=${page}${(str.length>2)?str:''}");
    var tmp =json.decode(response.body);
    totalPages = tmp["meta"]["pagination"]["pages"];
      if(totalPages<pageNo)
      {
        pageNo=totalPages;
        _refreshPage();
      }
    return compute(parseUsersList,response.body);
  }
  
  @override
  void initState() {
    super.initState();

    // initial load
    pageNo = 1;
    _futureUserList = _fetchUserList(filters,pageNo);
    cachedUserList[pageNo]=_futureUserList;
  }

  void _nextPage(){
    setState(() {
      if(pageNo<totalPages)
        pageNo+=1;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =_fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }
  
  void _previousPage()
  {
    setState(() {
      if(pageNo>1)
      {
        pageNo-=1;
        if(cachedUserList[pageNo]!=null)
        {
          _futureUserList=cachedUserList[pageNo];
        }
        else
        {
          _futureUserList =_fetchUserList(filters,pageNo);
          cachedUserList[pageNo]=_futureUserList;
        }
      }
    });
  }

  void _changePage(int page)
  {
     setState(() {
      pageNo=page;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =_fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }

  void _refreshPage(){
    setState(() {
        _futureUserList =_fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
    });
  }

  void _applyFilters(HashMap<String,String> newFilters)
  {
    setState(() {
      filters = newFilters;
      cachedUserList.clear();
      _futureUserList = _fetchUserList(filters,pageNo);
      cachedUserList[pageNo] = _futureUserList;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.fast_rewind_sharp),
                            onPressed:(){_changePage(1);}
                            ),
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed:_previousPage
                            ),
                            SizedBox(
                              height: 50, 
                              child:  ListView.builder(
                              scrollDirection: Axis.horizontal,

                              shrinkWrap: true,
                              itemCount:5,
                              itemBuilder:(context,index){
                                 if(totalPages-pageNo>5)
                                  return new GestureDetector(
                                    child: Container(
                                      margin:EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 25,
                                      child: Text('${pageNo+index}',style:(index==0)?TextStyle(color:Colors.blue[800],fontWeight: FontWeight.w900,fontSize: 20):null ,)
                                      ),
                                    onTap:(){ _changePage(pageNo+index); },
                                  );
                                  else
                                    return new GestureDetector(
                                      child: Container(
                                        margin:EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        height: 25,
                                        width: 25,
                                        child: Text('${pageNo+index-4}',style:(index==4)?TextStyle(color:Colors.blue[800],fontWeight: FontWeight.w900,fontSize: 20):null ,)
                                        ),
                                      onTap:(){ _changePage(pageNo+index-4); },
                                    );
                              } 
                            
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed:_nextPage
                            ),
                          IconButton(
                            icon: Icon(Icons.fast_forward_sharp),
                            onPressed:(){_changePage(totalPages);}
                            ),
                        ],
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
                                cachedUserList[pageNo].then((value) => {
                                  for(int i=0;i<value.length;i++)
                                  {
                                    if(value[i].id==val.id)
                                    {
                                      value[i]=val
                                    }
                                  },
                                  cachedUserList[pageNo] = Future<List<User>>.value(value)
                                });
                              }
                              else
                              {
                                setState(() {
                                  _futureUserList = _fetchUserList(filters,pageNo);
                                  cachedUserList[pageNo] = _futureUserList;
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
                  return Text("${snapshot.error}");
                }
            }
            // By default, show a loading spinner.
            return Center(child:CircularProgressIndicator());
          },
        );
  }
}