import 'package:flutter/material.dart';
import 'package:frontsoc/pages/SimpleMapPage.dart';
import 'ListViewPage.dart';
import 'MapViewPage.dart';
import 'OnlineRegistrations.dart';
import 'SettingsPage.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Bottom Sheet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // Logic for filtering communities
      },
      icon: Icon(icon, color: Colors.blueAccent),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            Icon(Icons.map, color: Colors.white), // Google Maps Icon
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search communities',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration, color: Colors.black),
              title: const Text("Online Registrations"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => OnlineRegistrations()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_border, color: Colors.black),
              title: const Text("Ratings"),
              onTap: () {
                // Add logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.black),
              title: const Text("Map"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SimpleMapPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => SettingsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main content - ListView and MapView
          Positioned.fill(
            child: Container(
              color: Colors.lightBlue[100],
              child: const DefaultTabController(
                length: 2,
                child: TabBarView(
                  children: [
                    ListViewPage(),
                    MapViewPage(),
                  ],
                ),
              ),
            ),
          ),

          // Categories (Cat, Dog, Animal, Blood Donation, Urgence)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton(Icons.pets, "Cat"),
                  const SizedBox(width: 10),
                  _buildCategoryButton(Icons.pets, "Dog"),
                  const SizedBox(width: 10),
                  _buildCategoryButton(Icons.nature_people, "Animal"),
                  const SizedBox(width: 10),
                  _buildCategoryButton(Icons.bloodtype, "Blood Donation"),
                  const SizedBox(width: 10),
                  _buildCategoryButton(Icons.warning, "Urgence"),
                ],
              ),
            ),
          ),

          // Floating button to open bottom sheet
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () => _showBottomSheet(context),
              child: const Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
