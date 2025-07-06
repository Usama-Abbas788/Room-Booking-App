import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../view_models/signup_vm.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  late SignUpViewModel signUpViewModel;
  @override
  void initState() {
    super.initState();
    signUpViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  cursorColor: Colors.green,
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, size: 17),
                    hintText: 'Email',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.green,
                  obscureText: !isPasswordVisible,
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 17),
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible =
                          !isPasswordVisible; // Toggle visibility
                        });
                      },
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  cursorColor: Colors.green,
                  obscureText: !isConfirmPasswordVisible,
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 17),
                    hintText: 'Confirm Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    ),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible =
                              !isConfirmPasswordVisible; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 45),
                Obx(() {
                  return signUpViewModel.isLoading.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      signUpViewModel.signup(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text
                      );
                    },
                    child: Text('Sign up', style: TextStyle(color: Colors.white)),
                  );
                }),
                SizedBox(height: 25),
                Text('or'),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed('/login');
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(color: Colors.green, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class SignUpBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(SignUpViewModel());
  }

}
