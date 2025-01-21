import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../consts/consts.dart';
import '../controllers/CommentController.dart';
import '../controllers/CommunityController.dart';
import '../controllers/UserController.dart';
import 'CategoryPage.dart';
import 'package:url_launcher/url_launcher.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});


  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final MapController _mapController = MapController(); // MapController instance
  double _currentZoom = 10.0; // Default zoom level
  bool _isLoading = true;
  String? _error;
  List<dynamic> _comments = [];
  // Instancier le controller avec Get.put()
  final CommentController commentController = Get.put(CommentController());
  // Use communityController instead of the previous community
  final CommunityController communityController = Get.put(CommunityController()); // GetX controller instance

  @override
  void initState() {
    super.initState();
    communityController.selectedCommunityName = "Community 1"; // Example

    // Ensure the community name is available
    final String? communityName = communityController.selectedCommunityName;
    print("Selected Community Name: $communityName");
    if (communityName != null && communityName.isNotEmpty) {
      commentController.getComments(communityName);
    } else {
      setState(() {
        _error = "Community name not available.";
      });
    }


    communityController.getAllCommunities().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _error = e.toString();
      });
    });
  }


// Zoom in function
  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 18.0); // Clamp zoom level to valid range
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  // Zoom out function
  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 18.0); // Clamp zoom level to valid range
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  // Method to fetch communities

  void _showCreateCenterDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController communityTypeController = TextEditingController();

    final CommunityController communityController = Get.put(CommunityController());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String description = '';
        double latitude = 0.0;
        double longitude = 0.0;

        return AlertDialog(
          title: const Text('Create New Center'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Community Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Community Description'),
                ),
                TextField(
                  controller: communityTypeController,
                  decoration: const InputDecoration(labelText: 'Community Type'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Create a community using the entered data
                String communityName = nameController.text;
                String communityDescription = descriptionController.text;
                String communityType = communityTypeController.text;
                String creationDate = DateTime.now().toIso8601String();

                // Call the controller's method to create/update community info
                communityController.setCommunityInfo(
                  communityName: communityName,
                  communityDescription: communityDescription,
                  communityType: communityType,
                  creationDate: creationDate,
                );

                // Optionally, show a success message or navigate away
                Get.snackbar('Success', 'Community created successfully');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Create'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }




  void _toggleMapView() {
    // Logic to toggle between different map types or views
    // This is a placeholder for whatever map view switching logic you may need
    setState(() {
      _error = null; // Reset any errors
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Toggled map view')),
    );
  }

  void _switchToListView() {
    // Logic to switch to a list view
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(title: Text('List of Locations')),
              body: Center(child: Text('Displaying List of Locations')),
            ),
      ),
    );
  }
  void _showBottomSheetMenu() {


    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true, // Allow it to take more space if needed
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search here",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.mic, color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                // "Explore Nearby" header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore Nearby",
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.blue),
                  ],
                ),
                SizedBox(height: 10.0),
                // Horizontal scrollable menu
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryIcon('assets/images/dog.png', 'Dog'),
                      _buildCategoryIcon('assets/images/cat.png', 'Cat'),
                      _buildCategoryIcon('assets/images/livestock.png', 'Animals'),
                      _buildCategoryIcon(Icons.bloodtype, 'Blood'),
                      _buildCategoryIcon(Icons.more_horiz, 'More'),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),
                // "Events" section
                Text(
                  "Events",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                // Horizontal scrollable events
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildEventCard("save dogs", "assets/images/4.png"),
                      _buildEventCard("save animals", "assets/images/3.png"),
                      _buildEventCard("", "assets/images/2.png"),
                      _buildEventCard("", "assets/images/1.png"),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper function to build category icons or images
// Helper function to build category icons or images
// Helper function to build category icons or images with navigation
  Widget _buildCategoryIcon(dynamic iconOrImagePath, String label) {
    return GestureDetector(
      onTap: () {
        _navigateToCategoryPage(label);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.blue[50],
              child: iconOrImagePath is IconData
                  ? Icon(
                iconOrImagePath,
                size: 20.0,
                color: iconOrImagePath == Icons.bloodtype
                    ? Colors.red
                    : Colors.blue, // Change color to red if it's the blood type icon
              )
                  : ClipOval(
                child: Image.asset(
                  iconOrImagePath,
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(label, style: TextStyle(fontSize: 10.0)),
          ],
        ),
      ),
    );
  }

// Function to navigate to the new page
  void _navigateToCategoryPage(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(title: category),
      ),
    );
  }



// Helper function for building event cards
  Widget _buildEventCard(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 120.0,
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
///**************************************************

  String _formatDate(String dateString) {
    DateTime? date;
    try {
      date = DateTime.parse(dateString);
    } catch (e) {
      return 'Invalid date';
    }

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months months ago';
    }
  }

  // BottomSheet method

  void _showBottomSheet(BuildContext context, Map<String, dynamic> community) {
    final CommentController commentController = Get.put(CommentController());
    commentController.getComments(community['communityName']); // Fetch comments

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  // Header with title and close button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community['communityName'] ?? 'Community Name',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Type: ${community['communityType'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Text(
                                community['communityDescription'] ?? 'No description available.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Contact Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.grey),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (community['contactInfo'] != null) {
                                  launchUrl('tel:${community['contactInfo']}');
                                }
                              },
                              child: Text(
                                community['contactInfo'] ?? 'N/A',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.grey),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (community['website'] != null) {
                                  launchUrl(community['website']);
                                }
                              },
                              child: Text(
                                community['website'] ?? 'N/A',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(Icons.directions, 'Directions'),
                        _buildActionButton(Icons.call, 'Call'),
                        _buildActionButton(Icons.language, 'Website'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Add Photos/Videos Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Photos/Videos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Add functionality to upload images or videos
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text('Upload Photos/Videos'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Comments Section
                  // Comments Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          if (commentController.comments.isEmpty) {
                            return Text('No comments yet.');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: commentController.comments.length,
                            itemBuilder: (context, index) {
                              final comment = commentController.comments[index];
                              return ListTile(
                                leading: CircleAvatar(child: Icon(Icons.person)),
                                title: Text(comment['senderEmail'] ?? 'Anonymous'),
                                subtitle: Text(comment['content'] ?? ''),
                              );
                            },
                          );
                        }),



                        TextField(
                          onSubmitted: (text) {
                            if (communityController.selectedCommunityName != null) {
                              commentController.addComment(
                                communityController.selectedCommunityName!,
                                text,
                              );
                            } else {
                              print("No community selected.");
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Write a comment",
                            border: OutlineInputBorder(),
                          ),
                        ),

                      ],
                    ),
                  ),


                  SizedBox(height: 20),

                  // Ratings Summary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Review Summary',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                             Text(
                              '3.7',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void launchUrl(String url) {
    // You can use `url_launcher` to open the phone or website
    // Ensure you add `url_launcher` in pubspec.yaml
    launch(url);
  }

// Helper method for building action buttons
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

// Helper method for image cards (if needed)
  Widget _buildImageCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(
          imagePath,
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Helper for rating bars
  Widget _buildRatingBar() {
    return Column(
      children: [
        _buildRatingLine(5, 60.0),
        _buildRatingLine(4, 30.0),
        _buildRatingLine(3, 20.0),
        _buildRatingLine(2, 10.0),
        _buildRatingLine(1, 5.0),
      ],
    );
  }

  Widget _buildRatingLine(int starCount, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$starCount'),
          SizedBox(width: 4),
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 4),
          Container(
            height: 8,
            width: width,
            color: Colors.amber,
          ),
          Positioned(
            top: 100.0, // Adjust the position based on your needs
            right: 10.0, // Adjust the position based on your needs
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _showCreateCenterDialog();
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.layers, color: Colors.black),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _switchToListView();
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.navigation, color: Colors.black),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _toggleMapView();
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.directions, color: Colors.blue),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dummy method to avoid errors

  ///*********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flutter map widget
          FlutterMap(
            options: MapOptions(
              center: LatLng(33.5731, -7.5898), // Default center location
              zoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),

              MarkerLayer(
                markers: communityController.communityInfos.map((community) {
                  if (community['location'] != null &&
                      community['location']['x'] != null &&
                      community['location']['y'] != null) {
                    return Marker(
                      point: LatLng(community['location']['x'], community['location']['y']),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          // Show bottom sheet when the marker is tapped
                          _showBottomSheet(context, community);
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    );
                  }
                  return Marker(
                    point: LatLng(0.0, 0.0), // Default to prevent crashes
                    builder: (ctx) => const SizedBox(),
                  );
                }).toList(),
              ),

            ],
          ),
          Positioned(
              bottom: 50,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'zoomIn', // Unique tag for each FAB
                    mini: true,
                    onPressed: _zoomIn,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'zoomOut',
                    mini: true,
                    onPressed: _zoomOut,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
          ),
          // Show loading indicator if data is still being fetched
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // Show error message if there's an error
          if (_error != null && !_isLoading)
            Center(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheetMenu,
        child: const Icon(Icons.menu),
      ),
    );
  }

}

void main() {
  // Initialisation des contrôleurs requis
  Get.put(UserController()); // Assurez-vous que UserController est défini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapViewPage(),
    );
  }
}