import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/data/AuthRepository.dart';
import 'package:get/get.dart';
import 'package:my_app/data/MediaRepository.dart';
import 'package:my_app/data/UserRepository.dart';
import 'package:my_app/models/user.dart';
class ProfileViewModel extends GetxController{
  AuthRepository authRepository = Get.find();
  UserRepository userRepository = Get.find();
  MediaRepository mediaRepository = Get.find();
  var isAdding=false.obs;
  var isDeleting=false.obs;
  final isLoading = false.obs;
  Rxn<XFile> image=Rxn<XFile>();
  final existingImageUrl = Rxn<String>();
  @override
  void onInit() {
    super.onInit();
    final userId = authRepository.getLoggedInUser()?.uid;
    if (userId != null) {
      getUser(userId,showNotFoundMessage: false); // Silent load
    }
  }
  Future<void> addUser(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      ) async {
    // Validate inputs first
    if (firstName.isEmpty) {
      Get.snackbar("Error", "Enter proper name");
      return;
    }
    if (lastName.isEmpty) {
      Get.snackbar("Error", "Enter proper name");
      return;
    }
    if (!email.contains("@")) {
      Get.snackbar("Error", "Enter proper email");
      return;
    }
    if (phoneNumber.isEmpty || phoneNumber.length < 11) {
      Get.snackbar("Error", "Enter proper phone number");
      return;
    }

    final userId = authRepository.getLoggedInUser()?.uid;
    if (userId == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    // Check if profile already exists
    final profileExists = await checkProfileExists(userId);
    if (profileExists) {
      Get.snackbar(
        "Profile Exists",
        "You already have a profile. Please update it instead.",
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );
      await Future.delayed(Duration(seconds: 4));
      Get.back();
      return;
    }

    isAdding.value = true;

    try {
      NewUser newUser = NewUser(
        "",
        userId,
        firstName,
        lastName,
        email,
        phoneNumber,
      );

      if (image.value != null) {
        var imageResult = await mediaRepository.uploadImage(image.value!.path);
        if (imageResult.isSuccessful) {
          newUser.image = imageResult.url;
        } else {
          Get.snackbar('Error uploading image',
              imageResult.error ?? "Could not upload image due to error");
          return;
        }
      }

      await userRepository.addUser(newUser);
      await getUser(newUser.userId);
      Get.offNamed('/customer_home_page');
      Get.snackbar('Profile saved', 'Profile saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'An error occurred ${e.toString()}');
      print(e);
    } finally {
      isAdding.value = false;
    }
  }
  final Rxn<NewUser> currentUser = Rxn<NewUser>(); // Reactive user object

  Future<void> getUser(String userId, {bool showNotFoundMessage = false}) async {
    try {
      if (showNotFoundMessage) {
        isAdding.value = true; // Show loading only if explicitly requested
      } // Show loading state
      final user = await userRepository.getUser(userId);
      if (user != null) {
        currentUser.value = user;
        existingImageUrl.value = user.image;
      } else if (showNotFoundMessage) {
        // Only show snackbar if explicitly allowed
        Get.snackbar('Info', 'Empty Profile Detected! Please take a moment to build it.');
      }
    } catch (e, stackTrace) {
      Get.snackbar('Error', 'Failed to fetch user: ${e.toString()}');
      print('Error fetching user: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isAdding.value = false;
    }
  }
  Future<void> updateUser(
      String firstName,
      String lastName,
      String email,
      String phoneNumber
      ) async {
    if (currentUser.value == null) return;

    isAdding.value = true;
    try {
      final updatedUser = NewUser(
        currentUser.value!.docId,
        currentUser.value!.userId,
        firstName,
        lastName,
        email,
        phoneNumber,
      )..image = existingImageUrl.value;

      if (image.value != null) {
        final result = await mediaRepository.uploadImage(image.value!.path);
        if (result.isSuccessful) {
          updatedUser.image = result.url;
          existingImageUrl.value = result.url;
        }
      }
      await userRepository.updateUser(updatedUser);
      currentUser.value = updatedUser;
      Get.back();
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> deleteUser(NewUser user) async {
    try {
      isDeleting.value = true;
      await userRepository.deleteUser(user);
      final currentUser = authRepository.getLoggedInUser();
      if (currentUser != null) {
        await currentUser.delete();
      }
      this.currentUser.value = null;
      Get.back();
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
      Get.snackbar('Account deleted', 'Your account has been deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete profile/account: ${e.toString()}');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<bool> checkProfileExists(String userId) async {
    try {
      final user = await userRepository.getUser(userId);
      return user != null;
    } catch (e) {
      print('Error checking profile existence: $e');
      return false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
  }

}