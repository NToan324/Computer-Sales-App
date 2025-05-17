import 'dart:convert';

import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'package:computer_sales_app/views/pages/client/login/signup_view.dart';
import 'package:computer_sales_app/views/pages/client/login/verifyemail_view.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _focusAndShowError(FocusNode node, String message) {
    FocusScope.of(context).requestFocus(node);
    showCustomSnackBar(context, message, type: SnackBarType.error);
  }

  Future<void> signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _focusAndShowError(_emailFocus, 'Please enter your email');
      return;
    }

    if (password.isEmpty) {
      _focusAndShowError(_passwordFocus, 'Please enter your password');
      return;
    }

    if (password.length < 6) {
      _focusAndShowError(_passwordFocus, 'Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);
    final authService = AuthService();

    try {
      final response = await authService.post('auth/login', {
        'email': email,
        'password': password,
      });
      print('Raw login response: $response'); // Debug log
      if (response == null || response['accessToken'] == null || response['user'] == null) {
        throw BadRequestException('Login failed: Invalid response format');
      }
      final mappedResponse = {
        'access_token': response['accessToken'],
        'user': response['user'],
      };
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', mappedResponse['access_token']);
      await prefs.setString('user', jsonEncode(mappedResponse['user']));
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(mappedResponse['user']);
        final role = mappedResponse['user']['role']?.toString().toUpperCase();
        if (role == 'ADMIN') {
          Navigator.pushReplacementNamed(context, 'admin');
        } else {
          Navigator.pushReplacementNamed(context, 'home');
        }
      }
    } on BadRequestException catch (e) {
      if (mounted) {
        showCustomSnackBar(context, e.message, type: SnackBarType.error);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Unexpected error: $e', type: SnackBarType.error);
      }
    } finally {
      setState(() => _loading = false);
    }
  }
  Future<void> _isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final userJson = prefs.getString('user');
    if (accessToken != null && userJson != null) {
      if (mounted) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        final userRole = user['role']?.toString().toUpperCase();
        if (userRole == 'ADMIN') {
          Navigator.pushReplacementNamed(context, 'admin');
        } else {
          Navigator.pushReplacementNamed(context, 'home');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'Back',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: 250,
                        child: Text(
                          'Let\'s Get You Sign In !',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
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
                            final identifier = _emailController.text.trim();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VerifyEmailView(userId: identifier),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          splashColor: AppColors.primary.withAlpha(20),
                          highlightColor: AppColors.primary.withAlpha(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MyButton(
                      text: 'Sign In',
                      isLoading: _loading,
                      onTap: (_) => signIn(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpView(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        splashColor: Colors.orange.withAlpha(20),
                        highlightColor: Colors.orange.withAlpha(20),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
