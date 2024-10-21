import 'package:flutter/material.dart';

class RoundedCircularButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Define the onPressed parameter

  const RoundedCircularButton({
    super.key,
    required this.text,
    this.onPressed, // Add the onPressed parameter here
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the onPressed parameter here
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
