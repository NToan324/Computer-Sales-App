import "package:computer_sales_app/config/color.dart";
import "package:computer_sales_app/views/pages/client/login/signup_view.dart";
import "package:computer_sales_app/views/pages/client/login/verifyemail_view.dart";
import "package:computer_sales_app/views/pages/client/login/widgets/button.dart";
import "package:computer_sales_app/views/pages/client/login/widgets/text_field.dart";
import "package:computer_sales_app/services/auth.service.dart";
// import 'package:computer_sales_app/views/pages/client/home/home_view.dart';
import "package:flutter/material.dart";

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signIn(BuildContext context) async {
    final authService = AuthService();
    final email = userNameController.text.trim(); // email hoặc phone
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      await authService.login(email, password);
      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Hi Welcome Back!',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 159, 159, 159),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 1,
                    width: 150,
                    color: const Color.fromARGB(255, 159, 159, 159),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: userNameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          final identifier = userNameController.text.trim();
                          if (identifier.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter your email or phone first')),
                            );
                            return;
                          }
                          // Điều hướng tới VerifyEmailView, truyền identifier làm userId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VerifyEmailView(userId: identifier),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyButton(
                    text: 'Sign In',
                    onTap: (ctx) => signIn(ctx),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpView()),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
