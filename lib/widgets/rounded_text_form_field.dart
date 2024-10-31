import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged; // Add this line
  final String? Function(String?)? validator; // Add this line
  const RoundedTextFormField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged, // Add this line
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(67, 71, 77, 0.08),
            spreadRadius: 10,
            blurRadius: 40,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged, // Use onChanged here
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.blue,
              ),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle: const TextStyle(
                fontSize: 10,
                color: Color.fromRGBO(131, 143, 160, 100),
              ),
              hintText: hintText,
            ),
            obscureText: obscureText,
          ),
        ),
      ),
    );
  }
}
