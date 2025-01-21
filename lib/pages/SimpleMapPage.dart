import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SimpleMapPage extends StatelessWidget {
  const SimpleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Map Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(33.5731, -7.5898), // Centre initial : Casablanca
          zoom: 10.0, // Niveau de zoom initial
        ),
        children: [
          // Fond de carte OpenStreetMap
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          // Ajout d'un exemple de marqueur
          MarkerLayer(
            markers: [
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng(33.5731, -7.5898), // Coordonnées pour Casablanca
                builder: (context) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
