import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart'; // Add this to use Get.snackbar
import '../controllers/UserController.dart';
import '../widgets/rounded_circular_button.dart';
import '../widgets/rounded_text_form_field.dart';
import 'HomePage.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late UserController controller;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserController());
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
        _loginForm(),
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
              "Sign In",
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

  Widget _loginForm() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Container(
        color: const Color.fromRGBO(255, 255, 255, 1.0),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RoundedTextFormField(
            controller: emailController,
            hintText: "Email Address",
            prefixIcon: Icons.email_outlined,
          ),
          RoundedTextFormField(
            controller: passwordController,
            hintText: "Password",
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          GestureDetector(
            onTap: () => {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
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
          child: RoundedCircularButton(
            text: "Sign In",
            onPressed: () async {
              // Call validateForm and print the result for debugging
              if (!validateForm()) {
                print("Validation failed"); // Debugging output
                return;
              }

              String email = emailController.text.trim();
              await controller.getUser(email);

              // Check if user exists
              if (controller.users.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(title: '',)),
                );
              } else {
                _showError("User not found. Please check your email or sign up.");
              }
            }
            ,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: const Text(
              "I Don't Have an Account",
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

  // Helper function to validate the form
  bool validateForm() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("All fields are required. Please fill in both fields.");
      return false;
    }

    if (!_isEmailValid(email)) {
      _showError("Invalid email format. Please enter a valid email.");
      return false;
    }


    return true;
  }

  // Helper function to validate email format
  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  // Helper function to show error message

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

}
