import 'package:flutter/material.dart';
import 'package:frontsoc/pages/HomePage.dart';
import 'package:frontsoc/pages/LoginPage.dart';

import 'package:flutter/material.dart';
import 'package:frontsoc/pages/HomePage.dart';
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(30, 88, 241, 1),
        ),
        useMaterial3: true,
      ),
      home: const HomePage( title: '',), // Affiche directement la HomePage
    );
  }
}



 */

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


