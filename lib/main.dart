import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition_ml/camera_page.dart';
import 'package:text_recognition_ml/text_recognition.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(MyApp(
    cameras: _cameras,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.cameras,
  }) : super(key: key);
  List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPage(
        cameras: cameras,
      ),
    );
  }
}
