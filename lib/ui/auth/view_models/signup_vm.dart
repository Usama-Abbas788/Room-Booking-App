import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/AuthRepository.dart';
import 'package:get/get.dart';
class SignUpViewModel extends GetxController{
  AuthRepository authRepository = Get.find();
  var isLoading=false.obs;
  Future<void> signup(String email, String password, String confirmPassword) async {
    if(!email.contains("@")){
      Get.snackbar("Error", "Enter proper email");
      return;
    }
    if(password.length<6){
      Get.snackbar("Error", "Password must be 6 characters long");
      return;
    }
    if(password!=confirmPassword){
      Get.snackbar("Error", "Password and confirm password must match");
      return;
    }
    isLoading.value=true;
    try{
      await authRepository.signup(email, password,);
      Get.back();
      Get.snackbar('Info', 'Signed up successfully');
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error", e.message??"Signup failed");
    }finally{
      isLoading.value=false;
    }
  }
  bool isUserLoggedIn(){
    return authRepository.getLoggedInUser()!=null;
  }
}