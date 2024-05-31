import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.onTap,
    required this.text,
    this.color = Colors.blue,
    this.borderRadius = BorderRadius.zero,
  });

  VoidCallback? onTap;
  String text;
  Color color;
  BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 16, 28, 38),
            Colors.blueAccent,
          ]),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        )),
      ),
    );
  }
}
