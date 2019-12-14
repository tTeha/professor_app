import 'package:course_montoring/View/courses.dart';
import 'package:course_montoring/View/dashboard.dart';
import 'package:course_montoring/View/login.dart';
import 'package:course_montoring/View/register.dart';
import 'package:flutter/material.dart';

void main() {
  final String title = '';
  runApp(
    MaterialApp(
        title: 'Flutter CRUD App',
//        home: LoginPage(title: 'Flutter CRUD API'),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          'login/': (BuildContext context) => LoginPage(title: title),
          'dashboard/': (BuildContext context) => DashboardPage(title: title),
          'register/': (BuildContext context) => RegisterPage(title: title),
          'addCourse/': (BuildContext context) => AddCoursePage(title: title),
        }),
  );
}
