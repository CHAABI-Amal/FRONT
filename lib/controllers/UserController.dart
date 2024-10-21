import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/UserModel.dart';
import '../consts/consts.dart';

class UserController extends GetxController {

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null); // For image file handling

  // Declare an observable list to store UserModel objects
  RxList<UserModel> users = <UserModel>[].obs;

  // Static user data for testing
  final List<UserModel> staticUsers = [
    UserModel(name: 'John Doe', email: 'john@example.com', password: 'password123', gender: 'Male', age: 30, address: '123 Street', imageUrl: null),
    UserModel(name: 'Jane Smith', email: 'jane@example.com', password: 'password456', gender: 'Female', age: 28, address: '456 Avenue', imageUrl: null),
  ];

  Future<void> addUser() async {
    // Check if debugging
    if (isdebug) {
      // Create a new user instance from the form inputs
      final userData = UserModel(
        name: nameTextController.text,
        email: emailTextController.text,
        password: passwordTextController.text,
        gender: genderTextController.text,
        age: int.tryParse(ageTextController.text),
        address: addressTextController.text,
        imageUrl: selectedImage.value != null ? selectedImage.value!.path : null,
      );

      // Add user data to static users list
      staticUsers.add(userData);
      users.value = List.from(staticUsers); // Update observable list
      Get.snackbar('Success', 'User added successfully (Debug Mode)');
      return; // Exit early from method
    }

    // Production code to add user
    Uri url = Uri.parse('${baseurl}adduser');

    // Collecting data from the form
    final userData = UserModel(
      name: nameTextController.text,
      email: emailTextController.text,
      password: passwordTextController.text,
      gender: genderTextController.text,
      age: int.tryParse(ageTextController.text),
      address: addressTextController.text,
      imageUrl: selectedImage.value != null ? selectedImage.value!.path : null,
    );

    try {
      var response = await http.post(
        url,
        body: jsonEncode(userData.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Add user data to static users list
        staticUsers.add(userData);
        users.value = List.from(staticUsers); // Update observable list
        Get.snackbar('Success', 'User added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred: $e');
    }
  }


  Future<void> getUser() async {
    // Check if debugging
    if (isdebug) {
      // Return static users in debug mode
      users.value = List.from(staticUsers);
      return; // Exit early from method
    }

    Uri url = Uri.parse("${baseurl}getuser");

    try {
      // Await the HTTP GET request
      var res = await http.get(url);

      // If the request is successful (status code 200)
      if (res.statusCode == 200) {
        // Parse the response body as a list of UserModel objects
        var data = List<UserModel>.from(
            jsonDecode(res.body).map((e) => UserModel.fromJson(e))
        ).toList();

        // If the data is not null, assign it to the users observable
        if (data != null) {
          users.value = data;
        }
      } else {
        // Handle unsuccessful response status code
        Get.snackbar("Error", "Failed to retrieve users: ${res.statusCode}");
      }
    } catch (e) {
      // Show an error message if an exception occurs
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Optional: Image picker handler
  void pickImage(File? image) {
    selectedImage.value = image;
  }
}
