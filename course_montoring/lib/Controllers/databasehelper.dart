import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  String serverURL = "http://teha43.pythonanywhere.com";
  bool status = false;
  var token = '';
  List<String> dataList = [];
  String error = '';

  Future<dynamic> userLogin(String username, String password) async {
//    print("username = $username, password = $password");
    String myURL = "$serverURL/login/";
    final response = await http.post(
      myURL,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'username': '$username',
        'password': '$password',
      },
    );
    var data = json.decode(response.body);
    print('statusCode = ${response.statusCode}');
    print('body = ${response.body}');
//    Map mapValue = json.decode(response.body);
//    print('mapValue =  ${mapValue.toString()}');
    if (response.statusCode == 200) {
//      print('data : ${data["token"]}');
      status = true;
      if (data["Error"] != null) {
        print('Error : ${data["Error"]}');
        error = data["Error"];
      } else {
        _saveToken(data["token"]);
        _saveId(data['user']['id']);
        dataList.add("${data['token']}");
        dataList.add("${data['user']['id']}");
        print("${data['user']['username']}");
      }
    } else {
      status = false;
    }
  }

  Future<dynamic> userRegister(String username, String password) async {
    String myURL = "$serverURL/register/";
    final response = await http.post(
      myURL,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'username': '$username',
        'password': '$password',
        'is_teacher': 'true',
      },
    );
    var data = json.decode(response.body);
    print('statusCode = ${response.statusCode}');
    print('body = ${response.body}');
//    Map mapValue = json.decode(response.body);
//    print('mapValue =  ${mapValue.toString()}');
    if (response.statusCode == 201) {
//      print('data : ${data["token"]}');
      status = true;
      if (data["Error"] != null) {
        print('Error : ${data["Error"]}');
        error = data["Error"];
      } else {
        dataList.add("${data['id']}");
        dataList.add("${data['username']}");
        dataList.add("${data['is_teacher']}");
        dataList.add("${data['is_student']}");
      }
    } else {
      status = false;
      if (data["username"] != null) {
        print('warning : ${data["username"]}');
        error = data['username'][0];
      }
    }
  }

  Future<dynamic> addCourse(List courseData, File imgFile, int id) async {
    String myURL = "$serverURL/teacher/$id/courses/";
    FormData formData = new FormData.fromMap({
      "name": "${courseData[0]}",
      "time": "${courseData[1]}",
      "seats": "${courseData[2]}",
      "short_description": "${courseData[3]}",
      "main_img": await MultipartFile.fromFile(imgFile.path,
          filename: "${imgFile.path.split('/').last}"),
      "majors": "${courseData[4]}",
    });
    Response _response;
    try {
      Dio dio = new Dio();
      _response = await dio.post(myURL, data: formData);
    } catch (e) {
      status = false;
      print(e);
    }
    if (_response.statusCode == 201) {
      status = true;
      return _response.data;
    }
    return [false];
  }

  Future<dynamic> addCourseMaterials(List<File> files, int id) async {
    String myURL = "$serverURL/course/$id/materials/";
    print("files diooooooooo =  $files");

    try {
      for (int i = 0; i < files.length; i++) {
        Response _response;
        FormData _formData = new FormData.fromMap({
          "file1": await MultipartFile.fromFile(files[i].path,
              filename: "${files[i].path.split('/').last}"),
        });
        Dio dio = new Dio();
        _response = await dio.post(myURL, data: _formData);
      }
    } catch (e) {
      status = false;
      print(e);
      return [false];
    }
    status = true;
    return [true];
  }

  Future<List> getCourses(int id) async {
    String myURL = "$serverURL/teacher/$id/courses/";
    Response dioResponse;
    try {
      Dio dio = new Dio();
      dioResponse = await dio.get(myURL);
      print("dio data = ${dioResponse.data}");
      print("dio headers = ${dioResponse.headers}");
      print("dio request = ${dioResponse.request}");
      print("dio statusCode = ${dioResponse.statusCode}");
    } catch (e) {
      print(e);
    }
    if (dioResponse.statusCode == 200) return dioResponse.data;
    return [false];
  }

  Future<List> getCourseMaterials(int id) async {
    String myURL = "$serverURL/course/$id/materials/";
    Response dioResponse;
    try {
      Dio dio = new Dio();
      dioResponse = await dio.get(myURL);
      print("dio data = ${dioResponse.data}");
      print("dio headers = ${dioResponse.headers}");
      print("dio request = ${dioResponse.request}");
      print("dio statusCode = ${dioResponse.statusCode}");
    } catch (e) {
      print(e);
    }
    if (dioResponse.statusCode == 200) return dioResponse.data;
    return [false];
  }

  Future<dynamic> getCourse(int teacherId, int id) async {
    String myURL = "$serverURL/teacher/$teacherId/course/$id/";
    final response = await http.get(
      myURL,
      headers: {
        'Accept': 'application/json',
//        'Authorization': '$token $readToken()',
      },
    );
    print("statusCode = ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) return json.decode(response.body);
    return false;
  }

  Future<List> deleteCourse(int teacherId, int id) async {
    String myURL = "$serverURL/teacher/$teacherId/course/$id/";
    final response = await http.delete(
      myURL,
      headers: {
        'Accept': 'application/json',
//        'Authorization': '$token $readToken()',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
      status = true;
      return [true];
    }
    return [false];
  }

  Future<dynamic> updateCourse(
      int teacherId, int id, List courseData, File imgFile) async {
    String myURL = "$serverURL/teacher/$teacherId/course/$id/";
    FormData formData;
    Response _response;
    if (imgFile != null) {
      formData = new FormData.fromMap({
        "name": "${courseData[0]}",
        "time": "${courseData[1]}",
        "seats": "${courseData[2]}",
        "short_description": "${courseData[3]}",
        "main_img": await MultipartFile.fromFile(imgFile.path,
            filename: "${imgFile.path.split('/').last}"),
        "majors": "${courseData[4]}",
      });
    } else {
      formData = new FormData.fromMap({
        "name": "${courseData[0]}",
        "time": "${courseData[1]}",
        "seats": "${courseData[2]}",
        "short_description": "${courseData[3]}",
        "majors": "${courseData[4]}",
      });
    }

    try {
      Dio dio = new Dio();
      _response = await dio.patch(myURL, data: formData);
    } catch (e) {
      status = false;
      print(e);
    }
    if (_response.statusCode == 200) {
      status = true;
      return _response.data;
    }
    return [false];
  }

  _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  _saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'id';
    final value = '$id';
    prefs.setString(key, value);
  }

  Future<String> readId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'id';
    final value = prefs.get(key) ?? 0;
    print('read id : $value');
    return value;
  }

  Future<String> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read toke : $value');
    return value;
  }

  clearSP() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
