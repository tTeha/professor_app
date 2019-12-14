import 'package:course_montoring/Controllers/databasehelper.dart';
import 'package:course_montoring/View/courses.dart';
import 'package:course_montoring/View/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int id;

//  int getID() {
//    int myId;
//    void getId(String teacherId) {
//      print("teacherId = $teacherId");
//      myId = int.parse(teacherId);
//    }
//
//    Future<String> teacherId = databaseHelper.readId();
//    teacherId.then((value) => getId(value)).catchError((e) => 499);
//    return myId;
//  }

  @override
  void initState() {
    super.initState();
    databaseHelper.readId().then((result) {
      print("result: $result");
      setState(() {
        id = int.parse(result);
      });
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
            child: Text("Courses List"),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddCoursePage(),
            ));
          },
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder<List>(
              future: databaseHelper.getCourses(id),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text('Press button to start');
                  case ConnectionState.waiting:
                    return new Text('Awaiting result...');
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return new ItemList(list: snapshot.data);
                }
              },
              /************************/
//              builder: (context, snapshot) {
//                if (snapshot.hasError) print(snapshot.error);
//                return snapshot.hasData
//                    ? new ItemList(list: snapshot.data)
//                    : Center(
//                        child: CircularProgressIndicator(),
//                      );
//              },
            ),
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => ShowCoursePage(
                          list: list,
                          index: i,
                          courseId: list[i]['id'],
                          teacherId: list[i]['teacher'],
                        )),
              ),
              child: Card(
                color: Colors.red.shade800,
                child: ListTile(
                  title: Text(
                    list[i]['name'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Icon(Icons.apps),
                  subtitle: Text(
                    'seats : ${list[i]['seats']}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
