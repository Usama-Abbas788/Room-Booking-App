import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../view_models/reset_password_vm.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController emailController;
  late ResetPasswordViewModel resetPasswordViewModel;

  @override
  void initState() {
    super.initState();
    emailController=TextEditingController(text: Get.arguments);
    resetPasswordViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text('Reset Password',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                Text('Set a new password for your account',style: TextStyle(fontSize: 16),),
                SizedBox(height: 75,),
                TextField(
                  cursorColor: Colors.green,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.black87
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                SizedBox(height: 95,),
                Obx(() {
                  return resetPasswordViewModel.isLoading.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 70,vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      resetPasswordViewModel.reset(
                          emailController.text);
                    },
                    child: Text('Continue',style: TextStyle(color: Colors.white),),
                  );
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(ResetPasswordViewModel());
  }
}
