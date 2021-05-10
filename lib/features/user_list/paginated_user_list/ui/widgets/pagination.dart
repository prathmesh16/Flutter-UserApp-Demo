import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pagination extends StatelessWidget{

  int totalPages;
  int pageNo;

  var callbackChangePage;
  var callbackNextPage;
  var callbackPreviousPage;

  Pagination({this.totalPages,this.pageNo,this.callbackChangePage,this.callbackNextPage,this.callbackPreviousPage});

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.fast_rewind_sharp),
                onPressed:(){callbackChangePage(1);}
                ),
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed:callbackPreviousPage
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
                        onTap:(){ callbackChangePage(pageNo+index); },
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
                          onTap:(){ callbackChangePage(pageNo+index-4); },
                        );
                  } 
                
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed:callbackNextPage
                ),
              IconButton(
                icon: Icon(Icons.fast_forward_sharp),
                onPressed:(){callbackChangePage(totalPages);}
                ),
            ],
          );
  }
}