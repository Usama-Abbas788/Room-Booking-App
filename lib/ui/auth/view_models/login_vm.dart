import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data/AuthRepository.dart';
import 'package:get/get.dart';
class LoginViewModel extends GetxController{
  AuthRepository authRepository = Get.find();
  var isLoading=false.obs;
  Future<void> login(String email, String password) async {
    if(!email.contains("@")){
      Get.snackbar("Error", "Enter proper email");
      return;
    }
    if(password.length<6){
      Get.snackbar("Error", "Password must be 6 characters long");
      return;
    }
    isLoading.value=true;
    try{
      await authRepository.login(email, password);
      if(email=='m0790704@gmail.com' && password=='123456'){
        Get.offAndToNamed('/admin_home_page');
      }else{
        Get.offAndToNamed('/customer_home_page');
      }
    }on FirebaseAuthException catch(e){
      Get.snackbar("Create account", "Username or password is incorrect.");
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> confirmLogout() async {
    try{
      Get.back();
      await authRepository.logout();
      Get.offAllNamed('/login');
      Get.snackbar('Logout', "Logged out successfully");
    } catch(e){
      Get.snackbar('Error', "Failed to logout: ${e.toString()}");
    }
  }

  bool isUserLoggedIn(){
    return authRepository.getLoggedInUser()!=null;
  }

  String? getLoggedInUserEmail() {
    return authRepository.getLoggedInUserEmail();
  }

}