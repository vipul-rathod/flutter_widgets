import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final onTap;
  final bool isButtonPressed;
  final double? height;
  final double? width;
  const MyCustomButton({super.key, this.onTap, required this.isButtonPressed, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isButtonPressed ? [
            // no shadows if the button is pressed
          ] : [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(16, 16),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(-6, -6),
              blurRadius: 15,
              spreadRadius: 1,
            )
          ],
        ),
      child: Icon(
        Icons.add_box,
        size: 60,
        color: Colors.blue[400],
      ),
    ),
    );
  }
}