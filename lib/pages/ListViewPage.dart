import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListViewPage(),
    );
  }
}


class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<Map<String, dynamic>> _helpLocations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchHelpLocations();
  }

  // Simule l'obtention des emplacements avec des données statiques
  Future<void> fetchHelpLocations() async {
    await Future.delayed(const Duration(seconds: 2)); // Simule un délai
    setState(() {
      _helpLocations = [
        {
          'id': 1,
          'name': 'Location 1',
          'latitude': 33.5731,
          'longitude': -7.5898,
          'status': 'Active'
        },
        {
          'id': 2,
          'name': 'Location 2',
          'latitude': 34.0209,
          'longitude': -6.8416,
          'status': 'Inactive'
        },
        {
          'id': 3,
          'name': 'Location 3',
          'latitude': 32.293,
          'longitude': -6.553,
          'status': 'Pending'
        },
      ];
      _isLoading = false;
    });
  }

  // Supprime un emplacement en fonction de son ID
  void deleteHelpLocation(int id) {
    setState(() {
      _helpLocations.removeWhere((location) => location['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location $id deleted')),
    );
  }

  // Affiche une boîte de dialogue pour modifier un emplacement
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
              setState(() {
                location['name'] = nameController.text;
                location['status'] = statusController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
                        location['name'] ?? 'Unnamed Location',
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
