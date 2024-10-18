import 'package:flutter/material.dart';
import 'package:frontsoc/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(
              30,
              88,
              241,
              1,
            )),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
