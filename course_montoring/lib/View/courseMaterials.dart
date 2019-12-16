import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_montoring/Controllers/databasehelper.dart';
import 'package:course_montoring/View/dashboard.dart';
import 'package:course_montoring/View/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/*   ShowMaterialsPage      */

// ignore: must_be_immutable
class AddCourseMaterialPage extends StatefulWidget {
  AddCourseMaterialPage({Key key, this.title, this.courseId}) : super(key: key);
  final String title;
  int courseId;
  @override
  AddCourseMaterialPageState createState() => AddCourseMaterialPageState();
}

class AddCourseMaterialPageState extends State<AddCourseMaterialPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<File> _files;

  void _openFileExplorer() async {
    try {
      var files = await FilePicker.getMultiFile(type: FileType.ANY);
//      print("File wikaaaaaaaa = ${files[0]}");
      setState(() {
        _files = files;
//        print("files_list = $_files");
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  _onPressed() {
    setState(() {
      print('onPress_files_list =  $_files');
      if (_files != null) {
        dynamic addCourse =
            databaseHelper.addCourseMaterials(_files, widget.courseId);
        addCourse.whenComplete(() {
          if (databaseHelper.status) {
            databaseHelper.dataList = [];
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new DashboardPage(),
            ));
          } else {
            _showDialog('Error', "Correct your data");
          }
        });
      } else {
        _showDialog("Warning", "You haven't choose any file");
      }
    });
  }

  void _showDialog(String alertType, String alertStr) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$alertType'),
            content: Text('$alertStr'),
            actions: <Widget>[
              RaisedButton(
                  child: Text('close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("${widget.title}"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new DashboardPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                databaseHelper.clearSP();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: Container(
          child: ListView(
            padding: const EdgeInsets.only(
                top: 62, left: 12.0, right: 12.0, bottom: 12.0),
            children: <Widget>[
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('images/course04.jpg'),
                        maxRadius: 50.0,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: RaisedButton(
                          color: Colors.lightBlueAccent.shade200,
                          onPressed: _openFileExplorer,
                          child: Text("Upload materials"),
                        ),
                      ),
                      new Builder(
                        builder: (BuildContext context) => _files != null
                            ? new Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                child: new Scrollbar(
                                    child: new ListView.separated(
                                  itemCount: _files != null && _files.isNotEmpty
                                      ? _files.length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath =
                                        _files != null && _files.isNotEmpty;
                                    final String name = 'File $index: ' +
                                        (isMultiPath
                                            ? _files[index].path.split('/').last
                                            : '...');
                                    final path = isMultiPath
                                        ? _files[index].path.toString()
                                        : '...';

                                    return new ListTile(
                                      title: new Text(
                                        name,
                                      ),
                                      subtitle: new Text(path),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          new Divider(),
                                )),
                              )
                            : new Container(),
                      ),
                      SizedBox(
                        width: 250.0,
                        height: 20.0,
                        child: Divider(
                          color: Colors.black45,
                        ),
                      ),
                      RaisedButton(
                        onPressed: _onPressed,
                        color: Colors.red.shade800,
                        child: Text(
                          'Add Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*   ShowMaterialsPage      */

// ignore: must_be_immutable
class ShowMaterialsPage extends StatefulWidget {
  ShowMaterialsPage({this.courseId});
  int courseId;
  @override
  ShowMaterialsPageState createState() => ShowMaterialsPageState();
}

class ShowMaterialsPageState extends State<ShowMaterialsPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<String> _files = [];

  @override
  void initState() {
    super.initState();
    databaseHelper.getCourseMaterials(widget.courseId).then((result) {
      setState(() {
        print("reult length = ${result.length}");
        for (int i = 0; i < result.length; i++) {
          _files.add(result[i]['file1'].toString());
          Image image = Image.network(result[i]['file1']);
          print("image = ${image}");
        }
      });
    });
  }

  Future<dynamic> downloadFile(String url) async {
    Directory appDocDir = await getExternalStorageDirectory();
    String dir = appDocDir.path;
    print("appDocDir = $appDocDir");
    String fileName = url.split('/').last;
    File file = new File('$dir/$fileName');
    var request = await http.get(
      url,
    );
    var bytes = await request.bodyBytes;
    await file.writeAsBytes(bytes);
    print(" path ========= ${file.path}");
  }

  ListView filesList() {
    List<Widget> myList = [];
    if (_files.length > 0) {
      for (int i = 0; i < _files.length; i++) {
//        myList.add(
//          Container(
//            child: Image.network(
//              _files[i],
//              height: 300,
//            ),
//          ),
//        );
        myList.add(
          Container(
            child: CachedNetworkImage(
              imageUrl: _files[i],
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        );
        myList.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              onPressed: () {
                downloadFile(_files[i]);
              },
              child: Text("File $i: ${_files[i].split('/').last}"),
            ),
          ),
        );
        myList.add(
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
        );
      }
    }
    return ListView(
      padding: EdgeInsets.only(top: 62, left: 12.0, right: 12.0, bottom: 12.0),
      children: myList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Details',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("Courses Details"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new DashboardPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                databaseHelper.clearSP();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
          ],
        ),
        body: Container(
          child: filesList(),
        ),
      ),
    );
  }
}
