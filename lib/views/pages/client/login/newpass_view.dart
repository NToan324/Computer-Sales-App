import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';

class CreateNewPasswordView extends StatelessWidget {
  final passwordController = TextEditingController();
  final confirmedpasswordController = TextEditingController();

  CreateNewPasswordView({super.key});

  void newPass(BuildContext context) async {
    final password = passwordController.text.trim();
    final confirmedPassword = confirmedpasswordController.text.trim();

    if (password.isEmpty || confirmedPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    // Kiểm tra mật khẩu và mật khẩu xác nhận có khớp không
    if (password != confirmedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Kiểm tra độ dài mật khẩu (có thể thêm các kiểm tra khác như ký tự đặc biệt, chữ hoa...)
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    try {
      final auth = AuthService();
      // Gọi API để reset mật khẩu
      await auth.forgetPasswordReset(id: '', newPassword: password);  // Pass the user ID here as needed
      // Nếu thành công, chuyển hướng hoặc thông báo cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.pushReplacementNamed(context, 'login');  // Quay lại trang đăng nhập
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: $e')),
      );
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
            Navigator.pop(context); // Quay lại trang trước
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
                      onTap: newPass,  // Gọi phương thức tạo mật khẩu mới
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
