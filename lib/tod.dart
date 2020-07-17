import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as p;

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => new MyPageState();
}

class MyPageState extends State<MyPage> {
  var items = new List<String>();
  var indx = 0;
  var edt = false;
  var txtDList = new List<TextDecoration>();
  var txtDDone = new List<String>();
  var itemIds = new List<int>();
  final myController = TextEditingController();
  Database db;
  String dbPath;
  final _height = 3.0;
  final width = 100;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    create_and_Open_DB_and_GetData();
    txtDDone.length;
  }

  Future create_and_Open_DB_and_GetData() async {
    Directory path = await getApplicationDocumentsDirectory();
    dbPath = p.join(path.path, "db2.db");
    print("db path = $dbPath");
    db = await openDatabase(dbPath, version: 1, onCreate: this.createTable);
    getData();
  }

  Future createTable(Database db, int version) async {
    await db.execute(
        """CREATE TABLE IF NOT EXISTS todoItem (id INTEGER PRIMARY KEY,item TEXT NOT NULL,done TEXT NOT NULL)""");
    await db.close();
  }

  Future getData() async {
    db = await openDatabase(dbPath);
    var count = Sqflite.firstIntValue(
        await db.rawQuery('select count(*) from todoItem'));
    if (count != 0) {
      try {
        List<Map> list = await db.rawQuery('SELECT * FROM todoItem');
        await db.close();
        items.clear();
        txtDDone.clear();
        txtDList.clear();
        itemIds.clear();
        for (int i = 0; i < list.length; i++) {
          items.add(list[i]["item"]);
          txtDDone.add(list[i]["done"]);
          itemIds.add(list[i]["id"]);
        }
        for (int i = 0; i < txtDDone.length; i++) {
          if (txtDDone[i] == 'true') {
            txtDList.insert(i, TextDecoration.lineThrough);
          } else {
            txtDList.insert(i, TextDecoration.none);
          }
        }
        setState(() {});
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(


      appBar: PreferredSize(
        preferredSize:Size.fromHeight(76.0),child:new AppBar(



        elevation: 0,
        title:Column(children: <Widget>[

          Text(
          'My Tasks',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 24),
        ),
SizedBox(height: 1),
          Text(
            '" ${txtDList.length} Task "',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 16),

          ),


          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),

                ),
                height: _height,


              ),
              AnimatedContainer(
                height: _height,


                width: ( txtDDone.length/100)  * 100,
                color: Colors.red,
                duration: Duration(milliseconds: 300),
              ),
            ],
          ),

        ]),

        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),

      ),),
      body: makeListView(),

      floatingActionButton: Container(  child: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              edt = false;
              _showDialog();
            }),
      ),)
    );
  }

  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(
                        "              New Task",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ]),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "What task are you planning to perform?",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: Colors.grey),
                          ),
                        ])
                  ]),
              contentPadding: const EdgeInsets.all(16.0),
              content: Container(
                  height: 360,
                  child: Column(children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new TextField(

                            controller: myController,
                            autofocus: true,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "   Your Task...",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      height: 47,
                      width: 170,
                      child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.purple,
                          onPressed: () async {
                            await changeListView();
                            myController.text = "";
                            Navigator.pop(context);
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.add),
                            SizedBox(
                              width: 11,
                            ),
                            Text("Create Task",
                                style: TextStyle(
                                  fontSize: 16.0,
                                )),
                          ])),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 47,
                      width: 170,
                      child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.purple,
                          onPressed: () {
                            if (edt) {
                              edt = false;
                            }
                            myController.text = "";
                            Navigator.pop(context);
                          },
                          child: Row(children: <Widget>[
                            Icon(Icons.cancel),
                            SizedBox(
                              width: 11,
                            ),
                            Text("Cancel",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ])),
                    )
                  ])));
        });
  }

  changeListView() async {
    if (edt) {
      items[indx] = myController.text;
      try {
        db = await openDatabase(dbPath);
        await db.rawQuery('update todoItem set item = ? where id = ?',
            [myController.text, itemIds[indx]]);
        await db.close();
      } catch (e) {
        print("error in update: $e");
      }
    } else {
      if (items == null) {
        items = new List<String>();
        txtDDone = new List<String>();
      }
      try {
        items.add(myController.text);
        txtDDone.add("false");
        txtDList.add(TextDecoration.none);
      } catch (e) {
        print("error in adding: $e");
      }
      try {
        db = await openDatabase(dbPath);
        await db.rawQuery(
            'insert into todoItem(item,done) values("${myController.text}","false")');
        await db.close();
      } catch (e) {
        print("error in insert: $e");
      }
    }
    setState(() {});
  }

  Widget makeListView() {
    return new LayoutBuilder(builder: (context, constraint) {
      return new ListView.builder(
        itemCount: items.length == null ? 0 : items.length,
        itemBuilder: (context, index) {
          return new LongPressDraggable(
            key: new ObjectKey(index),
            data: index,
            child: new DragTarget<int>(
              onAccept: (int data) async {
                await _handleAccept(data, index);
              },
              builder: (BuildContext context, List<int> data,
                  List<dynamic> rejects) {

                return new Card(

color: Colors.transparent,
                  child:Container(

                      height:112,
                    child: new Column(
                  children: <Widget>[
SizedBox(height: 3,),
                    new ListTile(
                      leading: new IconButton(
                          icon: const Icon(Icons.check_box_outline_blank),
                          color: Colors.blue,
                          onPressed: () async {
                            indx = index;
                            await makeStrikeThoroughText();
                          }),
                      trailing: new IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () async {
                            indx = index;
                            await deleteValue();
                          }),
                      title: Text(
                        '${items[index]}',
                        style: TextStyle(decoration: txtDList[index]),
                      ),
                      onTap: () {
                        edt = true;
                        indx = index;
                        myController.text = items[index];
                        _showDialog();
                      },
                    ),
                  ],
                    ) ));
              },
              onWillAccept: (int data) {
                return true;
              },
            ),
            onDragStarted: () {
              Scaffold.of(context).showSnackBar(new SnackBar(
                backgroundColor: Colors.grey[600],
                content:
                    new Text("Please , yogita drag the row onto another row to change places"),
              ));
            },
            onDragCompleted: () {},
            feedback: new SizedBox(
                width: constraint.maxWidth,
                child: new Card(
                  child: Container(height: 112, color: Colors.transparent ,child:new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new IconButton(
                            icon: const Icon(Icons.check_box_outline_blank),
                            color: Colors.blue,
                            onPressed: () async {
                              indx = index;
                            }),
                        trailing: new IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () async {
                              indx = index;
                            }),
                        title: Text(
                          '${items[index]}',
                          style: TextStyle(decoration: txtDList[index]),
                        ),
                        onTap: () {
                          edt = true;
                          indx = index;
                          myController.text = items[index];
                        },
                      ),
                    ],
                  ),),
                  elevation: 18.0,
                )),
            childWhenDragging: new Container(

            ),
          );
        },
      );
    });
  }

  _handleAccept(int data, int index) async {
    String itemToMove = items[data];
    items.removeAt(data);
    items.insert(index, itemToMove);

    itemToMove = txtDDone[data];
    txtDDone.removeAt(data);
    txtDDone.insert(index, itemToMove);

    txtDList.clear();

    for (int i = 0; i < txtDDone.length; i++) {
      if (txtDDone[i] == "true") {
        txtDList.insert(i, TextDecoration.lineThrough);
      } else {
        txtDList.insert(i, TextDecoration.none);
      }
    }

    try {
      db = await openDatabase(dbPath);
      await db.rawQuery('delete from todoItem');
      await db.close();
    } catch (e) {
      print("error in deleting: $e");
    }

    for (int i = 0; i < items.length; i++) {
      try {
        db = await openDatabase(dbPath);
        await db.rawQuery(
            'insert into todoItem(item,done) values("${items[i]}","${txtDDone[i]}")');
        await db.close();
      } catch (e) {
        print("error in update: $e");
      }
    }

    setState(() {});
  }

  deleteValue() async {
    items.removeAt(indx);
    txtDDone.removeAt(indx);
    txtDList.removeAt(indx);

    try {
      db = await openDatabase(dbPath);
      await db.rawQuery('delete from todoItem where id = ?', [itemIds[indx]]);
      await db.close();
    } catch (e) {
      print("error in delete: $e");
    }
    setState(() {});
  }

  makeStrikeThoroughText() async {
    if (txtDDone[indx] == "true") {
      txtDDone[indx] = "false";
      txtDList[indx] = TextDecoration.none;
    } else {
      txtDDone[indx] = "true";
      txtDList[indx] = TextDecoration.lineThrough;
    }
    try {
      db = await openDatabase(dbPath);
      await db.rawQuery('update todoItem set done = ? where id = ?',
          ["${txtDDone[indx]}", itemIds[indx]]);
      await db.close();
    } catch (e) {
      print("error in update: $e");
    }
    setState(() {});
  }
}


