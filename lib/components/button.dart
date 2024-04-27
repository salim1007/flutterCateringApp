import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.width,required this.height, required this.title, required this.onPressed, required this.disable});

  final double width;
  final double height;
  final String title;
  final bool disable;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.white
        ),
        onPressed: disable? null : onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
