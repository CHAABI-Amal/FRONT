import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';

import '../consts/consts.dart'; // Import for JSON decoding

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<dynamic> _helpLocations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchHelpLocations();
  }

  // Fetch help locations from the server
  Future<void> fetchHelpLocations() async {
    try {
      final response = await http.get(Uri.parse('$baseURL/centers'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON and access the 'data' field
        final jsonResponse = json.decode(response.body);
        setState(() {
          _helpLocations = jsonResponse['data']; // Accessing the 'data' property
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load help locations');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  // Delete a help location by ID
  Future<void> deleteHelpLocation(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseURL/centers/$id'));

      if (response.statusCode == 200) {
        setState(() {
          _helpLocations.removeWhere((location) => location['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Center deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete the center');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Show dialog to edit help location
  void _showEditDialog(Map<String, dynamic> location) {
    TextEditingController nameController =
    TextEditingController(text: location['name']);
    TextEditingController statusController =
    TextEditingController(text: location['status']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Help Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Location Name'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle the edit action
              _editHelpLocation(location['id'], nameController.text,
                  statusController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Edit help location by ID
// Example error handling in Flutter to get more insights
  Future<void> _editHelpLocation(int id, String newName, String newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/centers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': newName, 'status': newStatus}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          final index = _helpLocations.indexWhere((loc) => loc['id'] == id);
          if (index != -1) {
            _helpLocations[index]['name'] = newName;
            _helpLocations[index]['status'] = newStatus;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Center updated successfully')),
        );
      } else {
        throw Exception('Failed to update the center. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _editHelpLocation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Locations')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _helpLocations.isEmpty
          ? const Center(child: Text('No help locations available.'))
          : ListView.builder(
        itemCount: _helpLocations.length,
        itemBuilder: (context, index) {
          final location = _helpLocations[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        location['name'] ??
                            'Unnamed Location',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () {
                              _showEditDialog(location);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              deleteHelpLocation(location['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Location: (${location['latitude']}, ${location['longitude']})',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Status: ${location['status'] ?? 'Unknown'}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
