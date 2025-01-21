import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../consts/consts.dart';
import 'UserController.dart';

class CommentController extends GetxController {


  // Function to get all comments from the API
  var comments = [].obs;
  final UserController userController = Get.find<UserController>();

  Future<void> getComments(String communityName) async {
    var url = Uri.parse('$baseURLCommunity/api/community_comment/get_all_flat');
    var headers = {'Content-Type': 'application/json'};

    try {
      print("Sending request to get comments for: $communityName");
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({"communityName": communityName}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          comments.value = data;
          print("Comments retrieved: $data");
        } else {
          print("Unexpected response format: $data");
          comments.value = [];
        }
      } else {
        print("Error fetching comments: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during request: $e");
    }
  }

  Future<void> addComment(String communityName, String commentText) async {
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUser email: ${userController.getCurrentUserEmail()}");

    var url = Uri.parse('$baseURLCommunity/api/community_comment/add');
    var headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'communityName': communityName,
      'senderEmail': userController.getCurrentUserEmail(),
      'content': commentText,
    });

    try {
      print("Sending request to add comment: $body");
      final response = await http.post(url, headers: headers, body: body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("Comment added successfully!");
        await getComments(communityName);
      } else {
        print("Error adding comment: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error during request: $e");
    }
  }

}