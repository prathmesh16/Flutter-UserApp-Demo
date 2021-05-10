import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/User.dart';
import './myWidgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './myWidgets/PopUpDialogAddUser.dart';
import './myWidgets/PopUpDialogFilters.dart';

// void main() => runApp(MaterialApp(home:MyApp()));

//converting response data into json list
List<User> parseUsersList(String body){
  var response = json.decode(body);
  var data = response["data"] as List;
  return data.map<User>((json) => User.fromJson(json)).toList();
}



//Application 
class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() =>_MyApp2State();
}

class _MyApp2State extends State<MyApp2> {

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
  int pageNo;
  int totalPages ;
  Future<List<User>> _futureUserList ;
  HashMap<String,String> filters = new HashMap<String, String>();
  //storage to cache users data
  var cachedUserList = <int, Future<List<User>>>{};
  //GET request to fetch users list
  Future < List<User>> fetchUserList(HashMap<String,String> filters,int page) async{
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

    final http.Response response = await http.get("https://gorest.co.in/public-api/users?page=${page}${(str.length>2)?str:''}");
    var tmp =json.decode(response.body);
    totalPages = tmp["meta"]["pagination"]["pages"];
      if(totalPages<pageNo)
      {
        pageNo=totalPages;
        refreshPage();
      }
    return compute(parseUsersList,response.body);
  }
  @override
  void initState() {
    super.initState();

    // initial load
    pageNo = 1;
    _futureUserList = fetchUserList(filters,pageNo);
    cachedUserList[pageNo]=_futureUserList;
  }

  void nextPage(){
    setState(() {
      if(pageNo<totalPages)
        pageNo+=1;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }
  
  void previousPage()
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
          _futureUserList =fetchUserList(filters,pageNo);
          cachedUserList[pageNo]=_futureUserList;
        }
      }
    });
  }

  void changePage(int page)
  {
     setState(() {
      pageNo=page;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }

  void refreshPage(){
    setState(() {
        _futureUserList =fetchUserList(filters,pageNo);
        cachedUserList[pageNo]=_futureUserList;
    });
  }

  void applyFilters(HashMap<String,String> newFilters)
  {
    setState(() {
      filters = newFilters;
      cachedUserList.clear();
      _futureUserList = fetchUserList(filters,pageNo);
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
                            onPressed:(){changePage(1);}
                            ),
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed:previousPage
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
                                    onTap:(){ changePage(pageNo+index); },
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
                                      onTap:(){ changePage(pageNo+index-4); },
                                    );
                              } 
                            
                            ),
                            ),
                            // Container(
                            //   height: 28,
                            //   width: 25,
                            //   child: Text(
                            //     '${pageNo}',
                            //     style: TextStyle(color:Colors.blue[800],fontWeight: FontWeight.w900,fontSize: 20) ,
                            //     ),
                            // ),
                            // new GestureDetector(
                            //   child: Container(
                            //     height: 20,
                            //     width: 20,
                            //     child: Text('${pageNo+1}')
                            //     ),
                            //   onTap:(){ changePage(pageNo+1); },
                            // ),
                            // new GestureDetector(
                            //  child: Container(
                            //     height: 20,
                            //     width: 20,
                            //     child: Text('${pageNo+2}')
                            //     ),
                            //   onTap:(){ changePage(pageNo+2);},
                            // ),
                            // new GestureDetector(
                            //  child: Container(
                            //     height: 20,
                            //     width: 20,
                            //     child: Text('${pageNo+3}')
                            //     ),
                            //   onTap:(){ changePage(pageNo+3);},
                            // ),
                            // new GestureDetector(
                            //   child: Container(
                            //     height: 20,
                            //     width: 20,
                            //     child: Text('${pageNo+4}')
                            //     ),
                            //   onTap:(){ changePage(pageNo+4);},
                            // ),
                            // new GestureDetector(
                            //   child: Card(child:Container(
                            //     height: 30,
                            //     width: 30,
                            //     alignment: Alignment.center,
                            //     child: Text('${pageNo+4}')
                            //     )),
                            //   onTap:(){ changePage(pageNo+4);},
                            // ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed:nextPage
                            ),
                          IconButton(
                            icon: Icon(Icons.fast_forward_sharp),
                            onPressed:(){changePage(totalPages);}
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
                                  // _futureUserList = Future.value(users);
                                  // cachedUserList[pageNo] = _futureUserList;
                                });
                                
                                return ;
                              }
                              bool flag= true;
                              // for(List<String> filter in filters)
                              // {
                              //   if(!filter.contains(val.gender) && !filter.contains(val.status))
                              //     flag = false; 
                              // }
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
                                  _futureUserList = fetchUserList(filters,pageNo);
                                  cachedUserList[pageNo] = _futureUserList;
                                });
                              }
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  onRefresh:()async{ refreshPage();},
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