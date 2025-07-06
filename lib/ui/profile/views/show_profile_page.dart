import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/MediaRepository.dart';
import 'package:my_app/ui/profile/views/save_profile_page.dart';

import '../../../data/AuthRepository.dart';
import '../../../data/UserRepository.dart';
import '../view_models/profile_vm.dart';

class ShowProfilePage extends StatefulWidget {
  const ShowProfilePage({super.key});

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  final profileViewModel = Get.find<ProfileViewModel>();

  @override
  void initState() {
    super.initState();
    final userId = Get.find<AuthRepository>().getLoggedInUser()?.uid;
    if (userId != null) {
      profileViewModel.getUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile',style: TextStyle(fontWeight: FontWeight.bold),)),
      body: Obx(() {
        final user = profileViewModel.currentUser.value;
        if (user == null) {
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Empty profile...',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Create your profile by:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('1. Tap on '),
                  Icon(Icons.menu),
                  Text(' on the home screen.'),
                ],
              ),
              Text('2. Tap on the "Create profile" button.'),
            ],
          ));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              user.image == null
                  ? CircleAvatar(radius: 40, child: Icon(Icons.image))
                  : CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.image!),
                  ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Card(
                  elevation: 7,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: .8,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: .8,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                '${user.email}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: .8,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                '${user.phoneNumber}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Get.to(() => SaveProfilePage(existingUser: user));
                              },
                              child: Text('Edit profile ?',)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Confirm Delete'),
                      content: Text(
                        'Are you sure you want to delete this profile?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await profileViewModel.deleteUser(user);
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class ShowProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(MediaRepository());
    Get.put(ProfileViewModel());
  }
}
