import 'dart:io';

import 'package:course_montoring/Controllers/databasehelper.dart';
import 'package:course_montoring/View/courseMaterials.dart';
import 'package:course_montoring/View/dashboard.dart';
import 'package:course_montoring/View/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*       Add Course Details           */

class AddCoursePage extends StatefulWidget {
  AddCoursePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AddCoursePageState createState() => AddCoursePageState();
}

class AddCoursePageState extends State<AddCoursePage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus;
  File _img;
  String _major;
  List<String> _majors = ['development', 'design', 'business'];
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _timeController = new TextEditingController();
  final TextEditingController _seatsController = new TextEditingController();
  final TextEditingController _shortDescriptionController =
      new TextEditingController();

  void _openFileExplorer() async {
    try {
      var image = await FilePicker.getFile(type: FileType.IMAGE);
      print("imageFile = $image");
      print("imagePath =  ${image.path}");
      setState(() {
        _img = image;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  _onPressed() {
    setState(() {
      String name = _nameController.text.trim().toLowerCase();
      String time = _timeController.text.trim();
      String seats = _seatsController.text.trim();
      String shortDescription = _shortDescriptionController.text.trim();

      if (name.isNotEmpty &&
          time.isNotEmpty &&
          seats.isNotEmpty &&
          shortDescription.isNotEmpty &&
          _major != null) {
        List data = [
          name,
          time,
          seats,
          shortDescription,
          _major,
        ];
        print('my_list_data =  ${data}');

        void addCourse(String id) {
          dynamic addCourse =
              databaseHelper.addCourse(data, _img, int.parse(id));
          addCourse.then((result) {
            if (databaseHelper.status) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => AddCourseMaterialPage(
                    courseId: int.parse('${result['id']}'),
                    title: "Add Materials",
                  ),
                ),
              );
            } else {
              _showDialog('Error', "Correct your data");
            }
          });
        }

        Future<String> teacherId = databaseHelper.readId();
        teacherId.then((value) => addCourse(value)).catchError((e) => 499);
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
            child: Text("Add Course"),
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
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'name',
                          hintText: 'Place course name',
                          icon: Icon(Icons.book),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _timeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          hintText: 'Place Course Time',
                          icon: Icon(Icons.timer),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _seatsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Seats',
                          hintText: 'Place Course Seats',
                          icon: Icon(Icons.table_chart),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _shortDescriptionController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Short Description',
                          hintText: 'Place Course Description',
                          icon: Icon(Icons.description),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: RaisedButton(
                          color: Colors.lightBlue,
                          onPressed: _openFileExplorer,
                          child: Text(
                            "upload file",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      new Builder(
                        builder: (BuildContext context) => _img != null
                            ? new Container(
//                          padding: const EdgeInsets.only(bottom: 10.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                child: new Scrollbar(
                                    child: new ListView.separated(
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath = false;
                                    final String name = 'ImageFile: ' +
                                        (_img.path.split('/').last);
                                    final path = "${_img.path}";

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
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: new DropdownButton(
                          hint: Text("choos a major"),
                          value: _major,
                          items: <DropdownMenuItem>[
                            new DropdownMenuItem(
                              child: Text('${_majors[0]}'),
                              value: _majors[0],
                            ),
                            new DropdownMenuItem(
                              child: Text('${_majors[1]}'),
                              value: _majors[1],
                            ),
                            new DropdownMenuItem(
                              child: Text('${_majors[2]}'),
                              value: _majors[2],
                            ),
                          ],
                          onChanged: (value) => setState(() {
                            _major = value;
                          }),
                        ),
                      ),
                      RaisedButton(
                        onPressed: _onPressed,
                        color: Colors.red.shade800,
                        child: Text(
                          'Add Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
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

/*       Show Course Details           */

// ignore: must_be_immutable
class ShowCoursePage extends StatefulWidget {
  ShowCoursePage({this.index, this.list, this.courseId, this.teacherId});
  List list;
  int index;
  int courseId;
  int teacherId;
  @override
  ShowCoursePageState createState() => ShowCoursePageState();
}

class ShowCoursePageState extends State<ShowCoursePage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  void _deletePress() {
    dynamic deleteCourse =
        databaseHelper.deleteCourse(widget.teacherId, widget.courseId);
    deleteCourse.whenComplete(() {
      if (databaseHelper.status) {
        databaseHelper.dataList = [];
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new DashboardPage(),
        ));
//        Navigator.pop(context, 'delete');
      }
    });
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
              icon: Icon(Icons.cancel),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new LoginPage(),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new DashboardPage(),
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
              Container(
                height: 50,
                child: Text(
                  "Name : ${widget.list[widget.index]['name']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Time : ${widget.list[widget.index]['time']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Seats : ${widget.list[widget.index]['seats']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Short Description : ${widget.list[widget.index]['short_description']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Container(
                height: 50,
                child: Text(
                  "Majors : ${widget.list[widget.index]['majors']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Text(
                  " Created at : ${widget.list[widget.index]['created_on']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Text(
                  " Updated at : ${widget.list[widget.index]['modified_on']}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontFamily: 'TitilliumWeb',
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => EditCoursePage(
                          courseId: widget.courseId,
                          teacherId: widget.teacherId,
                        ),
                      ),
                    ),
                    color: Colors.lightBlue,
                    child: Text(
                      'Edit Course',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: _deletePress,
                    color: Colors.red.shade800,
                    child: Text(
                      'Delete Course',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ShowMaterialsPage(
                            courseId: widget.courseId,
                          ),
                        ),
                      );
                    },
                    color: Colors.green,
                    child: Text(
                      'Show Materials',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*        Edit Course       */

// ignore: must_be_immutable
class EditCoursePage extends StatefulWidget {
  EditCoursePage({this.courseId, this.teacherId});
  int courseId;
  int teacherId;

  @override
  EditCoursePageState createState() => EditCoursePageState();
}

class EditCoursePageState extends State<EditCoursePage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _seatsController = new TextEditingController();
  TextEditingController _shortDescriptionController =
      new TextEditingController();
  TextEditingController _majorsController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    databaseHelper.getCourse(widget.teacherId, widget.courseId).then((result) {
      print("result: ${result['name']}");
      setState(() {
        _nameController.text = "${result['name']}";
        _timeController.text = "${result['time']}";
        _seatsController.text = "${result['seats']}";
        _shortDescriptionController.text = "${result['short_description']}";
        _majorsController.text = "${result['majors']}";
      });
    });
  }

//  @override
//  void initState() {
//    _nameController = new TextEditingController(
//        text: widget.list[widget.index]['name'].toString());
//    _timeController = new TextEditingController(
//        text: widget.list[widget.index]['time'].toString());
//    _seatsController = new TextEditingController(
//        text: widget.list[widget.index]['seats'].toString());
//    _shortDescriptionController = new TextEditingController(
//        text: widget.list[widget.index]['short_description'].toString());
//    _majorsController = new TextEditingController(
//        text: widget.list[widget.index]['majors'].toString());
//    _teacherController = new TextEditingController(
//        text: widget.list[widget.index]['teacher'].toString());
//  }

  _updateCourse() {
    setState(() {
      String name = _nameController.text.trim().toLowerCase();
      String time = _timeController.text.trim();
      String seats = _seatsController.text.trim();
      String shortDescription = _shortDescriptionController.text.trim();
      String majors = _majorsController.text.trim();

      if (name.isNotEmpty && time.isNotEmpty) {
        List data = [
          name,
          time,
          seats,
          shortDescription,
          majors,
        ];
        int id = widget.courseId;
        dynamic updateCourse = databaseHelper.updateCourse(
            widget.teacherId, widget.courseId, data);
        updateCourse.whenComplete(() {
          if (databaseHelper.status) {
            print("dataList = ${databaseHelper.dataList}");
            databaseHelper.dataList = [];
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new DashboardPage(),
            ));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text("Edit Course"),
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
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'name',
                          hintText: 'Place course name',
                          icon: Icon(Icons.book),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _timeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          hintText: 'Place Course Time',
                          icon: Icon(Icons.timer),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _seatsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Seats',
                          hintText: 'Place Course Seats',
                          icon: Icon(Icons.table_chart),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _shortDescriptionController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Short Description',
                          hintText: 'Place Course Description',
                          icon: Icon(Icons.description),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _majorsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Major',
                          hintText: 'Place Course Major',
                          icon: Icon(Icons.school),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10)),
                      RaisedButton(
                        onPressed: _updateCourse,
                        color: Colors.lightBlue,
                        child: Text(
                          'Update Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
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
