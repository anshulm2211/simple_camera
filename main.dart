import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
void main(){
  runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      )

  );
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {

  String statusText = "Start Server";
  File _image;
  final String nodeEndPoint = 'http://192.168.43.158:3000/image';
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();

  Future getImage_camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    //_uploadFile(image);

    setState(() {
      _image = image;
    });
  }

  Future getImage_gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //_uploadFile(image);

    setState(() {
      _image = image;
    });
  }

  upload(){
//    setState(() {
//      statusText = "Starting server on Port : 8080";
//    });
//    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
//    print("Server running on IP : "+server.address.toString()+" On Port : "+server.port.toString());
//    await for (var request in server) {
//      request.response
//        ..headers.contentType = new ContentType(
//            "text", "plain", charset: "utf-8")
//        ..write(_image)
//        ..close();
//    }
//
//    setState(() {
//      statusText = "Server running on IP : "+server.address.toString()+" On Port : "+server.port.toString();
//    });

    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;
    print("sending");
    http.post(nodeEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
//
        key: _scaffoldstate,
        appBar: AppBar(

          title: Text('Simple Camera'),
          backgroundColor: Colors.redAccent,

        ),
        body: Center(

          child:  _image == null ? Text('No image selected.') : Image.file(_image),
        ),

        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      getImage_camera();
                    },
                    tooltip: 'camera',
                    child: Icon(Icons.camera),
                    backgroundColor: Colors.redAccent,
                  ),


                  FloatingActionButton(
                    onPressed: (){
                      getImage_gallery();
                    },
                    tooltip: 'gallery',
                    child: Icon(Icons.image),
                    backgroundColor: Colors.redAccent,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      upload();
                    },
                    tooltip: 'upload',
                    child: Icon(Icons.send),
                    backgroundColor: Colors.redAccent,
                  ),
                ]

            )
        )
    );
  }
}
