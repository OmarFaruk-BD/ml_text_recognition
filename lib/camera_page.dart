import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  @override
  void initState() {
    setControler();
    super.initState();
  }

  void setControler() async {
    WidgetsFlutterBinding.ensureInitialized();
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: CameraPreview(controller),
              ),
            ),
          ),
          FutureBuilder(
            future: getRecognisedText(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              }
              return const Text('eror');
            }),
          ),
        ],
      ),
    );
  }

  Future<String> getRecognisedText() async {
    pictureFile = await controller.takePicture();
    if (pictureFile == null) {
      return 'null...........';
    } else {
      final inputImage = InputImage.fromFilePath(pictureFile!.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      var recognisedText = await textDetector.processImage(inputImage);
      await textDetector.close();
      var scannedText = '';
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = "$scannedText${line.text}\n";
        }
      }
      setState(() {});
      return scannedText;
    }
  }
}
