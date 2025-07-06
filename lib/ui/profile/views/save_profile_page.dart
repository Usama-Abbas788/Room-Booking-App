import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/AuthRepository.dart';
import 'package:my_app/data/MediaRepository.dart';
import 'package:my_app/data/UserRepository.dart';
import 'package:my_app/ui/profile/view_models/profile_vm.dart';

import '../../../models/user.dart';

class SaveProfilePage extends StatefulWidget {
  final NewUser? existingUser;
  SaveProfilePage({super.key, this.existingUser});

  @override
  State<SaveProfilePage> createState() => _SaveProfilePageState();
}



class _SaveProfilePageState extends State<SaveProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late ProfileViewModel profileViewModel;

  @override
  void initState() {
    super.initState();
    profileViewModel = Get.find<ProfileViewModel>();
    profileViewModel.image.value = null;
    if (widget.existingUser != null) {
      firstNameController.text = widget.existingUser!.firstName;
      lastNameController.text = widget.existingUser!.lastName;
      emailController.text = widget.existingUser!.email;
      phoneController.text = widget.existingUser!.phoneNumber;
      profileViewModel.existingImageUrl.value = widget.existingUser!.image;
    } else {
      profileViewModel.existingImageUrl.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingUser != null ? 'Update Profile' : 'Create Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fill your information !',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('This information will be used for Booking.'),
              ),
              SizedBox(height: 10),
              Obx(() {
                if (profileViewModel.image.value != null) {
                  return CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(File(profileViewModel.image.value!.path)),
                  );
                }
                if (widget.existingUser != null &&
                    profileViewModel.existingImageUrl.value != null) {
                  return CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(profileViewModel.existingImageUrl.value!),
                  );
                }
                return CircleAvatar(radius: 40, child: Icon(Icons.image));
              }),
              TextButton(
                onPressed: () {
                  profileViewModel.pickImage();
                },
                child: Text(
                  widget.existingUser != null ? 'Update image' : 'Choose image',
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'First Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 9),
                          TextField(
                            cursorColor: Colors.green,
                            controller: firstNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Last Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 9),
                          TextField(
                            cursorColor: Colors.green,
                            controller: lastNameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 9),
              TextField(
                cursorColor: Colors.green,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 9),
              TextField(
                keyboardType: TextInputType.number,
                cursorColor: Colors.green,
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: '03*********',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Obx(() {
                return profileViewModel.isAdding.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 70,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        if (widget.existingUser != null) {
                          await profileViewModel.updateUser(
                            firstNameController.text,
                            lastNameController.text,
                            emailController.text,
                            phoneController.text,
                          );
                        } else {
                          await profileViewModel.addUser(
                            firstNameController.text,
                            lastNameController.text,
                            emailController.text,
                            phoneController.text,
                          );
                        }
                      },
                      child: Text(
                        widget.existingUser != null ? 'Update' : 'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(MediaRepository());
    Get.put(ProfileViewModel());
  }
}
