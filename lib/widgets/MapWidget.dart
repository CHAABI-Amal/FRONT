
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Community List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _pharmacies = [];
  bool _isLoading = true;
  String? _error;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: "List View"),
              Tab(icon: Icon(Icons.map), text: "Map View"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showAddPharmacyForm(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildListView(),
            _buildMapView(),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(child: Text('Error: $_error'))
        : _pharmacies.isEmpty
        ? const Center(child: Text('No pharmacies available.'))
        : ListView.builder(
      itemCount: _pharmacies.length,
      itemBuilder: (context, index) {
        final pharmacy = _pharmacies[index];
        return ListTile(
          title: Text(pharmacy['name'] ?? 'Unnamed Pharmacy'),
          subtitle: Text(
              'Location: (${pharmacy['locationX']}, ${pharmacy['locationY']})\nStatus: ${pharmacy['status'] ?? 'Unknown'}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {

            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'update', child: Text('Update')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(

      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),

      ],
    );
  }

  void showAddPharmacyForm(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationXController = TextEditingController();
    final TextEditingController locationYController = TextEditingController();
    final TextEditingController statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Pharmacy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: locationXController, decoration: const InputDecoration(labelText: 'Location X'), keyboardType: TextInputType.number),
              TextField(controller: locationYController, decoration: const InputDecoration(labelText: 'Location Y'), keyboardType: TextInputType.number),
              TextField(controller: statusController, decoration: const InputDecoration(labelText: 'Status')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
