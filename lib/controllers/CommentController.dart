import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../consts/consts.dart';
import 'UserController.dart';

class CommentController extends GetxController {


  // Function to get all comments from the API
  var comments = [].obs;
  final UserController userController = Get.find<UserController>();

  Future<void> getComments() async {
    var url = Uri.parse('$baseURLCommunity/api/community_comment/get_all_flat');
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request('GET', url);
    request.body = json.encode({
      "communityName": "Community 1" // Ensure this matches the expected field on the backend
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);

        // Assuming 'data' is an array of comments or adjust as necessary
        comments.value = data is List ? data : data['comments'] ?? [];
        print("Commentaires récupérés : $data");
      } else {
        print('Erreur lors de la récupération des commentaires: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la requête: $e');
    }
  }


  Future<void> addComment(String commentText) async {
    var url = Uri.parse('$baseURLCommunity/api/community_comment/add');
    var headers = {
      'Content-Type': 'application/json'
    };

    // Update the request body to match the expected fields
    final body = json.encode({
      'communityName': 'Community 1', // Use your dynamic community name if necessary
      'senderEmail': userController.getCurrentUserEmail(), // Use the current user's email dynamically
      'content': commentText, // Use the comment text passed to the function
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Commentaire ajouté avec succès !");
        // Optionally, fetch updated comments list after adding a new comment
        await getComments();
      } else {
        print('Erreur lors de l\'ajout du commentaire: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la requête: $e');
    }
  }

}
