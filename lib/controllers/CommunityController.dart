import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../consts/consts.dart';

class CommunityController extends GetxController {
  List communityInfos = [];

  // Function to get all communities
  Future<List> _getAllCommunities() async {
    var url = Uri.parse('$baseURLCommunity/api/community/get_all_communities');
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : [];
        print("Communities retrieved successfully: $data");
      } else {
        print('Error retrieving communities: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Request error: $e');
    }
    return [];
  }

  // Function to get info for a specific community
  Future<Map> getCommunityInfo(String communityName) async {
    var headers = {

      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('$baseURLCommunity/api/community/get_info'));
    request.body = json.encode({
      "communityName": "Community 1"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      return data is Map ? data : {};
    }
    else {
      print(response.reasonPhrase);
    }

    return {};
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

  // Function to get all communities
  Future<void> getAllCommunities() async {
    communityInfos = [];
    final ids = await _getAllCommunities();
    for (final id in ids) {
      final data = await getCommunityInfo(id);
      if (data == {}) {
        communityInfos.add(data);
      }

    }
  }
}
