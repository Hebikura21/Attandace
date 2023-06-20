// ignore_for_file: use_build_context_synchronously

/*import 'package:camera/camera.dart';
import 'package:final_project/pages/barcode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';


class DateTimeExample extends StatefulWidget {
  @override
  _DateTimeExampleState createState() => _DateTimeExampleState();
}

class _DateTimeExampleState extends State<DateTimeExample> {
  Timer? timer;
  DateTime? now;
  CameraController? controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    startTimer();
    getCameras();
    initializeCamera();
  }

    Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  List<CameraDescription>? cameras;

  Future<void> getCameras() async {
    cameras = await availableCameras();
  }

  @override
  void cameraState() {
    super.initState();
    getCameras();
    initializeCamera();
  }

  @override
  Widget camera() {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    );
  }

  void initializeCamera() {
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.medium);
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          // Camera initialization is complete
        });
      });
    } else {
      // Handle the case when cameras is null or empty
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(' MMMM  d  yyyy').format(now!);
    String formattedTime = DateFormat('HH : mm').format(now!);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 241, 233, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 187, 187, 187),
        automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(
                  tag: 'date',
                  child: Center(
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Hero(
                  tag: 'time',
                  child: Center(
                    child: Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "Jam",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Menit",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 5,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 80, 80, 81),
        onPressed: () async {
          bool cameraPermissionGranted = await requestCameraPermission();
          if (cameraPermissionGranted) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const QRViewExample();
            },)); 
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Camera permission denied"), 
              ),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
*/
