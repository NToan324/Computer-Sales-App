import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  _CreateNewPasswordViewState createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confirmedpasswordController = TextEditingController();
  bool _isLoading = false; // Thêm trạng thái loading

  Future<void> newPass(BuildContext context) async {
    final password = passwordController.text.trim();
    final confirmedPassword = confirmedpasswordController.text.trim();
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    if (password.isEmpty || confirmedPassword.isEmpty) {
      showCustomSnackBar(
        context,
        'Please enter all fields',
      );
      return;
    }

    if (password != confirmedPassword) {
      showCustomSnackBar(context, 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      showCustomSnackBar(
        context,
        'Password must be at least 6 characters long',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();
      await auth.forgetPasswordReset(id: userId, newPassword: password);
      showCustomSnackBar(context, 'Password reset successfully',
          type: SnackBarType.success);
      Navigator.pushReplacementNamed(context, 'login');
    } on BadRequestException catch (e) {
      showCustomSnackBar(context, e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: const Text(
                        'Your new password must be different from previously used passwords.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 159, 159, 159),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    MyTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      controller: passwordController,
                      obscureText: true,
                    ),
                    MyTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                      controller: confirmedpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MyButton(
                        text: 'Reset Password',
                        onTap: (_) => newPass(context),
                        isLoading: _isLoading, // Truyền trạng thái loading
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
