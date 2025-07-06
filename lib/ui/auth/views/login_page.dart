import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/ui/auth/view_models/login_vm.dart';
import '../../../data/AuthRepository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    loginViewModel = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLoggedIn = loginViewModel.isUserLoggedIn();
      final email = loginViewModel.getLoggedInUserEmail();

      if (isLoggedIn && email != null) {
        if (email == 'm0790704@gmail.com') {
          Get.offAllNamed('/admin_home_page');
        } else {
          Get.offAllNamed('/customer_home_page');
        }
      }
    });
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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/account.png'),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Log in',
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
                    prefixIcon: Icon(Icons.account_circle_rounded, size: 17),
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
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 17),
                    hintText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 0.5),
                    ),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                       var result = await Get.toNamed('/forget_password',arguments: emailController.text);
                       if(result is String){
                         Get.snackbar("Reset password", "A password reset email is sent to you at $result");
                       }
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Obx(() {
                  return loginViewModel.isLoading.value
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
                        onPressed: () {
                          loginViewModel.login(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                }),
                SizedBox(height: 25),
                Text('or'),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        'Sign up',
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
class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(LoginViewModel());
  }
}
