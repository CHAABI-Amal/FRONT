import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON decoding

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

  Future<void> fetchHelpLocations() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.109:3000/api/v1/centers'));

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
        // If the server does not return a 200 OK response, throw an exception
        throw Exception('Failed to load help locations');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString(); // Capture the error message
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(child: Text('Error: $_error'))
        : _helpLocations.isEmpty
        ? const Center(child: Text('No help locations available.'))
        : ListView.builder(
      itemCount: _helpLocations.length,
      itemBuilder: (context, index) {
        final location = _helpLocations[index];
        return ListTile(
          title: Text(location['name'] ?? 'Unnamed Location'),
          subtitle: Text(
            'Location: (${location['latitude']}, ${location['longitude']})\n'
                'Status: ${location['status'] ?? 'Unknown'}',
          ),
        );
      },
    );
  }
}
