import 'package:computer_sales_app/components/custom/myTextField.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/client/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _loading = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();

    super.dispose();
  }

  void _focusAndShowError(FocusNode node, String message) {
    FocusScope.of(context).requestFocus(node);
    showCustomSnackBar(context, message, type: SnackBarType.error);
  }

  Future<void> signUp() async {
    final name = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmedPasswordController.text.trim();

    if (name.isEmpty) {
      _focusAndShowError(_nameFocus, 'Please enter your full name');
      return;
    }

    if (email.isEmpty) {
      _focusAndShowError(_emailFocus, 'Please enter your email');
      return;
    }

    if (pass.isEmpty) {
      _focusAndShowError(_passwordFocus, 'Please enter your password');
      return;
    }

    if (confirm.isEmpty) {
      _focusAndShowError(_confirmFocus, 'Please confirm your password');
      return;
    }

    if (pass != confirm) {
      _confirmedPasswordController.clear();
      _focusAndShowError(_confirmFocus, 'Passwords do not match');
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = AuthService();
      await auth.signup(name: name, email: email, password: pass);
      await Future.delayed(const Duration(milliseconds: 1000));
      showCustomSnackBar(context, 'Sign up successfully',
          type: SnackBarType.success);
      Navigator.pop(context);
    } on BadRequestException catch (e) {
      showCustomSnackBar(context, e.message, type: SnackBarType.error);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Login',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: const Text(
                      'Fill the form below to create an account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  MyTextField(
                    hintText: 'Full Name',
                    prefixIcon: Icons.person,
                    controller: _userNameController,
                    focusNode: _nameFocus,
                    obscureText: false,
                  ),
                  MyTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    obscureText: false,
                  ),
                  MyTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: true,
                  ),
                  MyTextField(
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.lock,
                    controller: _confirmedPasswordController,
                    focusNode: _confirmFocus,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: 'Sign Up',
                    isLoading: _loading,
                    onTap: (_) => signUp(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginView(),
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
                            "Login",
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
