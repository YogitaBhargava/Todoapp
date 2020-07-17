import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:prac/main.dart';

import 'ca.dart';
import 'dbhelper.dart';
import 'dh.dart';



class Cat extends StatefulWidget {
  @override
  _CatState createState() => _CatState();
}

class _CatState extends State<Cat> {
  String newTask;
  Color taskColor;
  IconData taskIcon;
  final dbhelper = Databasehelper.instance;

  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>(

  );




  void addtodo( ) async {

    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);

    Navigator.push(context,MaterialPageRoute(builder: (context)=> MyApp()));
    todoedited = "";
    setState(() {
      validated = true;
      errtext = "";

    });
  }
@override
void initState(){
    super.initState();
  setState(() {
    newTask = '';
    taskColor = ColorUtils.defaultColors[0];
    taskIcon = Icons.work;
  });}


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "New Category",
            style: TextStyle(
                fontSize: 22,  color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black26),
        ),
        body: Container( height: 900,

          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 40,),
              Text("Category will  help you group related \ntask!",style: TextStyle(color: Colors.grey[500],fontSize: 16,fontWeight: FontWeight.bold),),
SizedBox(height: 40,),
              TextField(
cursorColor: taskColor,
                controller: texteditingcontroller,
                autofocus: true,
                onChanged: (_val) {
                  todoedited = _val;
                },
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.black

                ),

                decoration: InputDecoration(
                  errorText: validated ? null : errtext,
                  border: InputBorder.none,

                  hintText: "   Category Name...",
                  hintStyle: TextStyle(color: Colors.grey[400],fontSize: 36)
                ),
              ),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ColorPickerBuilder(
                      color: taskColor,
                      onColorChanged: (newColor) =>
                          setState(() => taskColor = newColor)),

                  IconPickerBuilder(
                      iconData: taskIcon,
                      highlightColor: taskColor,
                      action: (newIcon) =>
                          setState(() => taskIcon = newIcon)),



                ],
              ),
              SizedBox(height: 60,),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
SizedBox(height: 47, width: 200, child:
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      onPressed: () {
                        if (texteditingcontroller.text.isEmpty) {
                          setState(() {

                            errtext = "      Ummm... It seems that you are trying to add an invisible task \n      which is not allowed in this realm";

                            validated = false;
                          });
                        } else if (texteditingcontroller.text.length >
                            512) {
                          setState(() {
                            errtext = "Too may Characters";
                            validated = false;
                          });
                        } else {
                          addtodo(

                          );
                          
                        }
                      }, color: taskColor,

                      child:Row(
                          children: <Widget>[
                        Icon(Icons.save),
                        SizedBox(width: 11,),
                        Text("Create New Card",
                          style: TextStyle(
                            fontSize: 16.0,

                          )),])
                    )),

                  ],
                ),
              ),]
    )

        )
    );
  }}

class ColorPickerBuilder extends StatelessWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  ColorPickerBuilder({@required this.color, @required this.onColorChanged});

  @override
  Widget build(BuildContext context) {

    return ClipOval(
      child: Container(
        height: 32.0,
        width: 32.0,
        child: Material(
          color: color,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text('Select a color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        availableColors: ColorUtils.defaultColors,
                        pickerColor: color,
                        onColorChanged: onColorChanged,
                      ),
                    ),
                  );

                },
              );
            },
          ),
        ),
      ),
    );
  }
}


class IconPickerBuilder extends StatelessWidget {
  final IconData iconData;
  final ValueChanged<IconData> action;
  final Color highlightColor;

  IconPickerBuilder({
    @required this.iconData,
    @required this.action,
    Color highlightColor,
  }) : this.highlightColor = highlightColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.0),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Select an icon'),
              content: SingleChildScrollView(
                child: IconPicker(
                  currentIconData: iconData,
                  onIconChanged: action,
                  highlightColor: highlightColor,
                ),
              ),
            );
          },
        );
      },
      child: TodoBadge(
        id: 'id',
        codePoint: iconData.codePoint,
        color: highlightColor,
        outlineColor: highlightColor,
        size: 24,
      ),
    );
  }
}