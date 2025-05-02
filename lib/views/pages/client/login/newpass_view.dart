import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';

class CreateNewPasswordView extends StatefulWidget {
  CreateNewPasswordView({super.key});

  @override
  _CreateNewPasswordViewState createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final passwordController = TextEditingController();
  final confirmedpasswordController = TextEditingController();
  bool _isLoading = false; // Thêm trạng thái loading

  void newPass(BuildContext context) async {
    final password = passwordController.text.trim();
    final confirmedPassword = confirmedpasswordController.text.trim();
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    if (password.isEmpty || confirmedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    if (password != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();
      await auth.forgetPasswordReset(id: userId, newPassword: password);
      // Thêm độ trễ 1 giây để hiển thị hiệu ứng loading
      await Future.delayed(const Duration(milliseconds: 1000));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.pushReplacementNamed(context, 'login');
    } on BadRequestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
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
          icon: const Icon(Icons.arrow_back),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Your new password must be different from previously used passwords.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 159, 159, 159),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 1,
                      width: 150,
                      color: const Color.fromARGB(255, 159, 159, 159),
                    ),
                    const SizedBox(height: 60),
                    MyTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                      controller: confirmedpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 60),
                    MyButton(
                      text: 'Create New Password',
                      onTap: (_) => newPass(context),
                      isLoading: _isLoading, // Truyền trạng thái loading
                    ),
                    const SizedBox(height: 100),
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
