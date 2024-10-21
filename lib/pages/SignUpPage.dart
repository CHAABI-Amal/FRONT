import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/UserController.dart';
import '../widgets/rounded_circular_button.dart';
import '../widgets/rounded_text_form_field.dart';
import 'HomePage.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _ageController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late UserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UserController()); // Initialize controller
    controller.getUser(); // Load static users on init
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _header(),
        _signUpForm(),
        _userList(), // Affiche la liste des utilisateurs
      ],
    );
  }


  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      color: const Color.fromRGBO(230, 253, 253, 1.0),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          Image.asset(
            "assets/images/illustration.png",
            width: MediaQuery.of(context).size.width * 0.45,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }

  Widget _signUpForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(255, 255, 255, 1.0),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _formFields(),
                  const SizedBox(height: 20), // Space between address and button
                  _bottomButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget genderField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(67, 71, 77, 0.08),
            spreadRadius: 10,
            blurRadius: 40,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Colors.blue,
            ),
            const SizedBox(width: 10), // Space between icon and dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                hint: const Text(
                  "Select Gender",
                  style: TextStyle(fontSize: 10, color: Color.fromRGBO(131, 143, 160, 100)),
                ),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (value) {
                  // Handle gender change
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      int age = DateTime.now().year - picked.year;
      setState(() {
        _ageController.text = age.toString(); // Update the controller's text
      });
    }
  }
  Widget ageField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(67, 71, 77, 0.08),
              spreadRadius: 10,
              blurRadius: 40,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              const Icon(Icons.cake_outlined, color: Colors.blue),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  _ageController.text.isEmpty ? "Select Age" : _ageController.text,
                  style: const TextStyle(
                    fontSize: 16, // Adjusted font size for better readability
                    color: Color.fromRGBO(131, 143, 160, 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userList() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.users.length,
        itemBuilder: (context, index) {
          final user = controller.users[index];
          return ListTile(
            title: Text(user.name ?? 'No Name'), // Handle null case
            subtitle: Text(user.email ?? 'No Email'), // Handle null case
          );
        },
      );
    });
  }



  Widget _formFields() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImagePickerDialog(),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: controller.selectedImage.value != null
                ? FileImage(controller.selectedImage.value!)
                : null,
            child: controller.selectedImage.value == null
                ? const Icon(Icons.camera_alt, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        RoundedTextFormField(
          hintText: "Full Name",
          prefixIcon: Icons.person_outline,
          controller: controller.nameTextController,
        ),
        const SizedBox(height: 15),
        RoundedTextFormField(
          hintText: "Email Address",
          prefixIcon: Icons.email_outlined,
          controller: controller.emailTextController,
        ),
        const SizedBox(height: 15),
        RoundedTextFormField(
          hintText: "Password",
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: controller.passwordTextController,
        ),
        const SizedBox(height: 15),
        genderField(),
        const SizedBox(height: 15),
        ageField(),
        const SizedBox(height: 15),
        RoundedTextFormField(
          hintText: "Address",
          prefixIcon: Icons.home_outlined,
          controller: controller.addressTextController,
        ),
      ],
    );
  }

  Widget _bottomButtons() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: RoundedCircularButton(
            text: "Sign Up",
            onPressed: () async {
              await controller.addUser(); // Call addUser on button press
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        } else {
          print("No image selected.");
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else {
      print('Permission denied');
    }
  }


  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
