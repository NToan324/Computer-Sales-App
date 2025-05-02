import "package:computer_sales_app/config/color.dart";
import "package:computer_sales_app/services/app_exceptions.dart";
import "package:computer_sales_app/views/pages/client/login/signup_view.dart";
import "package:computer_sales_app/views/pages/client/login/verifyemail_view.dart";
import "package:computer_sales_app/views/pages/client/login/widgets/button.dart";
import "package:computer_sales_app/views/pages/client/login/widgets/text_field.dart";
import "package:computer_sales_app/services/auth.service.dart";
// import 'package:computer_sales_app/views/pages/client/home/home_view.dart';
import "package:flutter/material.dart";

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  // Sign user in method
  void signIn(BuildContext context) async {
    setState(() => _loading = true);
    final authService = AuthService();
    final email = userNameController.text.trim(); // email hoặc phone
    final password = passwordController.text.trim();

    try {
      await authService.login(email, password);
      await Future.delayed(const Duration(milliseconds: 1000));
      Navigator.pushReplacementNamed(context, 'home');
    } on BadRequestException catch (e) {
      // Ensure Snackbar is called with a valid context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }finally {
      setState(() {
        _loading = false; // Tắt loading
      });
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            final identifier = userNameController.text.trim();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VerifyEmailView(userId: identifier),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          splashColor: AppColors.primary.withOpacity(0.3), // Hiệu ứng sóng
                          highlightColor: AppColors.primary.withOpacity(0.1), // Hiệu ứng nhấn giữ
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                    ),
                  ),
                  const SizedBox(height: 40),
                  MyButton(
                    text: 'Sign In',
                    isLoading: _loading,
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
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpView()),
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          splashColor: Colors.orange.withOpacity(0.3),
                          highlightColor: Colors.orange.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
