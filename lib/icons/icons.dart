import 'package:flutter/material.dart';

class IconsCircle extends StatelessWidget {
  final String imagePath;
  const IconsCircle({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .center, // Menempatkan elemen di tengah secara horizontal
        children: [
          CircleAvatar(
            radius: 75, // Ubah ukuran radius sesuai kebutuhan Anda
            backgroundImage: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }
}
