import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../consts/consts.dart';

class CommunityController extends GetxController {
  List communityInfos = [];

  // Function to get all community names
  Future<List<String>> _getAllCommunities() async {
    var url = Uri.parse('$baseURLCommunity/api/community/get_all_communities');
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          print("Communities retrieved successfully: $data");
          return List<String>.from(data); // Ensure type safety
        }
      } else {
        print('Error retrieving communities: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Request error: $e');
    }

    return [];
  }

  // Function to get info for a specific community
  Future<Map<String, dynamic>> getCommunityInfo(String communityName) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
      'GET',
      Uri.parse('$baseURLCommunity/api/community/get_info'),
    );
    request.body = json.encode({"communityName": communityName});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = json.decode(await response.stream.bytesToString());
        if (data is Map) {
          return Map<String, dynamic>.from(data); // Explicitly cast to Map<String, dynamic>
        }
      } else {
        print('Error retrieving info for $communityName: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Request error: $e');
    }

    return {};
  }

  // Function to populate all communities
  Future<void> getAllCommunities() async {
    communityInfos = []; // Reset before fetching
    final communityNames = await _getAllCommunities();
    if (communityNames.isEmpty) {
      print("No communities found.");
      return;
    }

    for (final name in communityNames) {
      final data = await getCommunityInfo(name);
      if (data.isNotEmpty) { // Check if the retrieved info is not empty
        communityInfos.add(data);
      }
    }

    print("All communities retrieved: $communityInfos");
  }
  // Function to set/update info for a community
  Future<void> setCommunityInfo({
    required String communityName,
    required String communityDescription,
    required String communityType,
    required String creationDate,
  }) async {
    var url = Uri.parse('$baseURLCommunity/api/community/set_info');
    var headers = {
      'Content-Type': 'application/json',
    };
    var body = json.encode({
      "communityName": communityName,
      "communityDescription": communityDescription,
      "communityType": communityType,
      "creationDate": creationDate,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Community info updated successfully!");
      } else {
        print('Error updating community info: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Request error: $e');
    }
  }
}
