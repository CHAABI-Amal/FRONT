import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMapWidget(), // Your map or background widget here
          ),
          // Custom top-aligned Bottom Sheet
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Twins Garden",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text("3.8 (238)", style: TextStyle(color: Colors.black54)),
                                  SizedBox(width: 10),
                                  Icon(Icons.restaurant, size: 16, color: Colors.black54),
                                  Text("Restaurant • 1 min", style: TextStyle(color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.directions, 'Directions'),
                        _buildActionButton(Icons.start, 'Start'),
                        _buildActionButton(Icons.call, 'Call'),
                        _buildActionButton(Icons.save, 'Save'),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Image Gallery
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildImageCard('assets/images/1.png'),
                          _buildImageCard('assets/images/2.png'),
                          _buildImageCard('assets/images/3.png'),
                          _buildImageCard('assets/images/4.png'),
                        ],
                      ),
                    ),
                    Divider(),
                    // Overview, Menu, Reviews, etc.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabButton('Overview'),
                        _buildTabButton('Menu'),
                        _buildTabButton('Reviews'),
                        _buildTabButton('Photos'),
                        _buildTabButton('Updates'),
                      ],
                    ),
                    Divider(),
                    // Location and details
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.blue),
                      title: Text('R322, Mohammédia'),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time, color: Colors.green),
                      title: Text('Open'),
                      subtitle: Text('Closes 12 AM'),
                    ),
                    ListTile(
                      leading: Icon(Icons.language, color: Colors.blue),
                      title: Text('twinsgarden.ma'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  // Helper widget for image cards
  Widget _buildImageCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(imagePath, width: 100, fit: BoxFit.cover),
      ),
    );
  }

  // Helper widget for tabs
  Widget _buildTabButton(String label) {
    return TextButton(
      onPressed: () {},
      child: Text(label, style: TextStyle(color: Colors.black)),
    );
  }
}

// Dummy widget for the map
class FlutterMapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300], // Replace with your map widget
    );
  }
}
