// ignore_for_file: override_on_non_overriding_member

import 'package:camera/camera.dart';
import 'package:final_project/pages/barcode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    String formattedDate = DateFormat('MMMM d yyyy').format(now!);
    String formattedTime = DateFormat('HH:mm').format(now!);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 17, 45, 78), // Ubah warna AppBar sesuai kebutuhan
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: GoogleFonts.akshar(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF162A49), Color(0xFF2C3965)],
          ),
        ),
        child: Center(
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
                        style:
                            GoogleFonts.akshar(color: Colors.white, fontSize: 45),
                      ),
                    ),
                  ),
                ],
              ),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Hero(
                    tag: 'time',
                    child: Center(
                      child: Text(
                        formattedTime,
                        style:
                            GoogleFonts.akshar(color: Colors.white, fontSize: 100)
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
                  Text(
                    "Jam",
                    style: GoogleFonts.akshar(color: Colors.white, fontSize: 28)
                  ),
                  Text(
                    "Menit",
                    style: GoogleFonts.akshar(color: Colors.white, fontSize: 28)
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 5,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          bool cameraPermissionGranted = await requestCameraPermission();
          if (cameraPermissionGranted) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const QRBarcode();
              },
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Camera permission denied"),
              ),
            );
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
    );
  }
}
