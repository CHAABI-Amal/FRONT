import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  // Text Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();

  // List to hold user data
  var users = [].obs;



  Future<void> getUser(String email) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('GET', Uri.parse('http://192.168.0.105:9987/api/user/get_user'));
    request.body = json.encode({
      "userEmail": email
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = json.decode(await response.stream.bytesToString());
      users.add(data);
      print("Connexion réussie : ${data['fullName']}");
    }
    else {
      print('Erreur : ${response.reasonPhrase}');
    }
  }


  // Function to add a user
  Future<void> addUser() async {
    final url = Uri.parse('http://192.168.0.105:9986/api/auth/sing_up');

    // Vérifiez si tous les champs sont remplis
    if (emailTextController.text.isEmpty ||
        passwordTextController.text.isEmpty ||
        nameTextController.text.isEmpty ||
        birthDateTextController.text.isEmpty ||
        phoneNumberTextController.text.isEmpty ||
        addressTextController.text.isEmpty) {
      print("Tous les champs doivent être remplis !");
      return; // Arrêtez l'exécution si des champs sont vides
    }

    final body = json.encode({
      'email': emailTextController.text,
      'password': passwordTextController.text,
      'fullName': nameTextController.text,
      'birthDate': birthDateTextController.text,
      'phoneNumber': phoneNumberTextController.text,
      'address': addressTextController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("Utilisateur ajouté avec succès !");
      } else {
        print('Erreur lors de l\'ajout de l\'utilisateur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la requête: $e');
    }
  }


}
