import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleFile01 extends StatefulWidget {
  SingleFile01({Key key, this.title}) : super(key: key);
  final String title;

  @override
  SingleFile01State createState() => SingleFile01State();
}

class SingleFile01State extends State<SingleFile01> {
  File _img;

  void _openFileExplorer() async {
    try {
      var image = await FilePicker.getFile(type: FileType.ANY);
      print("File = $image");
      print("fielPath =  ${image.path}");
      print("fileName =  ${image.path.split('/').last}");
      setState(() {
        _img = image;
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green.shade700,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text("${widget.title}"),
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
                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: RaisedButton(
                          onPressed: _openFileExplorer,
                          child: Text("upload file"),
                        ),
                      ),
                      RaisedButton(
                        onPressed: _openFileExplorer,
                        color: Colors.green,
                        child: Text(
                          'Upload File',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.normal,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250.0,
                        height: 20.0,
                        child: Divider(
                          color: Colors.teal.shade100,
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
