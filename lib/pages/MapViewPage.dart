import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  List<dynamic> _helpLocations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchHelpLocations();
  }

  Future<void> fetchHelpLocations() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.109:3000/api/v1/centers'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _helpLocations = jsonResponse['data'];
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

  void _showDescription(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Center Description', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createCenter(String name, String description, double latitude, double longitude) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.109:3000/api/v1/centers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'type': 'ORPHANAGE', // Change this as needed or provide an option in the dialog
      }),
    );

    if (response.statusCode == 201) {
      // Successfully created the center
      fetchHelpLocations(); // Refresh the list of centers
    } else {
      throw Exception('Failed to create center');
    }
  }

  void _showCreateCenterDialog() {
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
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) => description = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => latitude = double.tryParse(value) ?? 0.0,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => longitude = double.tryParse(value) ?? 0.0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Create center using the entered data
                _createCenter(name, description, latitude, longitude);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : FlutterMap(
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
              Color markerColor = Colors.lightBlue[300]!;
              return Marker(
                width: 60.0,
                height: 60.0,
                point: LatLng(location['latitude'], location['longitude']),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showDescription(location['description']);
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCenterDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
