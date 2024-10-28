import 'package:flutter/material.dart';
import 'ListViewPage.dart';
import 'MapViewPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[300], // Adjusted for better contrast
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white), // Ensure text is readable
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list, color: Colors.white), text: "List View"),
              Tab(icon: Icon(Icons.map, color: Colors.white), text: "Map View"),
            ],
          ),
        ),
        body: Container(
          color: Colors.lightBlue[100], // Set the background color to a light sky blue
          child: const TabBarView(
            children: [
              ListViewPage(),
              MapViewPage(),
            ],
          ),
        ),
      ),
    );
  }
}
