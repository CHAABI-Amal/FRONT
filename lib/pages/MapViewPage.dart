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
import 'CategoryPage.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});


  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  List<Map<String, dynamic>> _helpLocations = [
    {"latitude": 33.5356324, "longitude":-7.6181929, "name": "Rabat"},
    {"latitude": 33.5900, "longitude": -7.6150, "name": "Marrakech"},
    {"latitude": 33.5460, "longitude": -7.6180, "name": "Casablanca"},
    {"latitude": 33.5971747, "longitude": -7.5285529, "name": "Casablanca"},
    // Ajouter d'autres emplacements si nécessaire
  ];
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
    fetchCommunities();

    commentController.getComments();
    communityController.getAllCommunities();

  }
  // Method to fetch communities
  fetchCommunities() async {
    try {
      // Call the method from the controller
      await communityController.getAllCommunities();

      // Check if data is loaded successfully
      if (communityController.communityInfos.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = 'No communities found';
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }
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

  void _showBottomSheet(BuildContext context) {
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
                  // Header with title, rating, and close button
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
                                'ERHAM Cat Shelter',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text('3.8 (238)', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 10),
                                  Text('Shelter · 1 min', style: TextStyle(fontSize: 12)),
                                ],
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

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(Icons.directions, 'Directions'),
                        _buildActionButton(Icons.star, 'Start'),
                        _buildActionButton(Icons.call, 'Call'),
                        _buildActionButton(Icons.save, 'Save'),
                      ],
                    ),
                  ),



                  // Section for adding photos/videos
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        ElevatedButton.icon(
                          onPressed: () {
                            // Functionality for adding photos or videos goes here
                          },
                          icon: Icon(Icons.add_a_photo),
                          label: Text('Add Photo/Video'),
                        ),
                      ],
                    ),
                  ),
                  // Images grid section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          _buildImageCard('assets/images/1.png'),
                          _buildImageCard('assets/images/2.png'),
                          _buildImageCard('assets/images/3.png'),
                          _buildImageCard('assets/images/4.png'),
                        ],
                      ),
                    ),
                  ),

                  // Text input section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onSubmitted: (commentText) {
                        // Ajouter un commentaire
                        commentController.addComment(commentText);
                      },
                      decoration: InputDecoration(
                        hintText: 'Ask the community',
                        prefixIcon: Icon(Icons.question_answer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),

                  // Ratings summary
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

                  // Rating bars
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildRatingBar(),
                  ),
                  Divider(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      if (commentController.comments.isEmpty) {
                        return Center(
                          child: Text(
                            'No comments yet',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            for (var comment in commentController.comments)

                              ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  comment['senderEmail'] ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12, // Reduced font size for email
                                  ),
                                ),


                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['content'] ?? '', // Display comment content
                                      style: TextStyle(fontSize: 14, color: Colors.black),
                                    ),
                                    Text(
                                      _formatDate(comment['lastUpdateDate'] ?? ''),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (index) {
                                    int rating = 3; // Replace this with actual rating if available
                                    return Icon(
                                      Icons.star,
                                      color: index < rating ? Colors.amber : Colors.grey,
                                      size: 16,
                                    );
                                  }),
                                ),

                              ),

                          ],
                        );
                      }
                    }),
                  ),

                  Divider(),

                  // Review Section
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('Abderrahman Aimara'),
                    subtitle: Text('9 months ago'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.grey),
                      ],
                    ),
                  ),
                  Divider(),

                  // Additional Info (Location, Hours, Website)
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.grey),
                    title: Text('R322, Mohammédia'),
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time, color: Colors.grey),
                    title: Text('Open · Closes 12 AM'),
                    trailing: Text('Open', style: TextStyle(color: Colors.green)),
                  ),
                  ListTile(
                    leading: Icon(Icons.language, color: Colors.grey),
                    title: Text('erhamcatshelter.ma'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        ],
      ),
    );
  }

  // Dummy method to avoid errors

  ///*********************************************************************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : Stack(
        children: [
          // Flutter map widget
          FlutterMap(
            options: MapOptions(
              center: LatLng(33.5731, -7.5898),
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _helpLocations.map((location) {
                  return Marker(
                    width: 60.0,
                    height: 60.0,
                    point: LatLng(location['latitude'], location['longitude']),
                    builder: (ctx) => GestureDetector(
                      onTap: () {
                            _showBottomSheet(context);
                          },

                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[300],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Positioned buttons
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheetMenu,
        child: Icon(Icons.menu),
      ),
    );
  }
}