import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import '../widgets/rounded_circular_button.dart';
import '../widgets/rounded_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  late UserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserController()); // Initialize controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _header(),
        _signUpForm(),
      ],
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      color: const Color.fromRGBO(230, 253, 253, 1.0),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          Image.asset(
            "assets/images/illustration.png",
            width: MediaQuery.of(context).size.width * 0.45,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }

  Widget _signUpForm() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        color: const Color.fromRGBO(255, 255, 255, 1.0),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _formFields(),
                _bottomButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Photo Placeholder
        GestureDetector(
          onTap: () {
            // Implement functionality to pick profile picture
          },
          child: const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        const RoundedTextFormField(
          hintText: "Full Name",
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 15),
        const RoundedTextFormField(
          hintText: "Email Address",
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 15),
        const RoundedTextFormField(
          hintText: "Password",
          prefixIcon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 15),
        const RoundedTextFormField(
          hintText: "Gender",
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 15),
        const RoundedTextFormField(
          hintText: "Age",
          prefixIcon: Icons.cake_outlined,
        ),
        const SizedBox(height: 15),
        const RoundedTextFormField(
          hintText: "Address",
          prefixIcon: Icons.home_outlined,
        ),
      ],
    );
  }

  Widget _bottomButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.06,
          child: const RoundedCircularButton(
            text: "Sign Up",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 30,
          ),
          child: GestureDetector(
            onTap: () => {
              // Navigate back to login page
            },
            child: const Text(
              "Already Have an Account? Sign In",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
