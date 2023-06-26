import 'package:final_project/pendukung/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

class QRBarcode extends StatefulWidget {
  const QRBarcode({Key? key});

  @override
  State<QRBarcode> createState() => _QRBarcodeState();
}

class _QRBarcodeState extends State<QRBarcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  bool isLoggedIn = false;
  bool snackBarShown = false;
  bool isLoggingIn = false;
  String qrCodeAPI =
      'https://absensi.codesantara.com/api/presences'; // URL API untuk mendapatkan kode QR
  bool isAbsenMasuk = true;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scannedData) {
      if (!isLoggedIn && !isLoggingIn) {
        _performLogin(scannedData.code!);
      }
    });
  }

  void _performLogin(String barcode) async {
    if (isLoggedIn || isLoggingIn) {
      return;
    }

    isLoggingIn = true;

    final headers = {
      'accept': 'application/json',
      'Authorization':
          'Bearer ${await DatabaseHelper.instance.getToken() ?? ''}',
    };
    final response = await http.post(
      Uri.parse(qrCodeAPI),
      headers: headers,
      body: {'barcode_code': barcode},
    );

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (barcode == response.body) {
        if (mounted) {
          setState(() {
            isLoggedIn = true;
          });
        }
          print(response.body);
          print(response.statusCode);
        if (!snackBarShown) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Absen Berhasil')),
          );
          snackBarShown = true;
        }

        if (isAbsenMasuk) {
          isAbsenMasuk = false;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavBarHome(data: '')),
          );
        }
      } else {
        if (!snackBarShown) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Absen Gagal')),
          );
          snackBarShown = true;
        }
      }
    } else {
      print(response.body);
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to perform attendance')),
      );
    }

    isLoggingIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 45, 78),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
