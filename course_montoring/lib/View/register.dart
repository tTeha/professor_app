import 'package:course_montoring/Controllers/databasehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

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

  _onPressed() {
    setState(() {
      String username = _usernameController.text.trim().toLowerCase();
      String password = _passwordController.text.trim();

      if (username.isNotEmpty && password.isNotEmpty) {
        dynamic register = databaseHelper.userRegister(username, password);
        register.whenComplete(() {
          if (databaseHelper.status) {
            if (databaseHelper.error.isNotEmpty) {
              _showDialog('Error', databaseHelper.error);
              databaseHelper.error = '';
            } else {
              databaseHelper.dataList = [];
              Navigator.pushReplacementNamed(context, 'login/');
            }
            msgStatus = 'success';
          } else {
            if (databaseHelper.error.isNotEmpty) {
              _showDialog('warning', databaseHelper.error);
              databaseHelper.error = '';
            }
          }
        });
      }
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
            child: Text("Teacher Register"),
          ),
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
                        backgroundImage: AssetImage('images/course01.png'),
                        maxRadius: 50.0,
                      ),
                      TextField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Place your username',
                        ),
                      ),
                      Padding(padding: new EdgeInsets.all(10)),
                      TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Place your password',
                        ),
                      ),
                      Padding(padding: new EdgeInsets.all(30)),
                      SizedBox(
                        width: 250.0,
                        height: 20.0,
                        child: Divider(
                          color: Colors.black45,
                        ),
                      ),
                      RaisedButton(
                        onPressed: _onPressed,
                        color: Colors.lightBlue,
                        child: Text(
                          'Register',
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
