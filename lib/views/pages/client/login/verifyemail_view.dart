import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';

class VerifyEmailView extends StatefulWidget {
  final String userId; // Dùng userId làm tham số
  const VerifyEmailView({super.key, required this.userId});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

Future<void> _sendCode() async {
  final email = _emailCtrl.text.trim();
  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter email')),
    );
    return;
  }

  setState(() => _loading = true);
  try {
    final auth = AuthService();
    final otpData = await auth.forgotPassword(email);
    final userId = otpData['id'];
    // Thêm độ trễ 1 giây để hiển thị hiệu ứng loading
    await Future.delayed(const Duration(milliseconds: 1000));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to your email')),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, 'verify-otp', arguments: userId);
    });
  } on BadRequestException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } finally {
    setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Container(
        width: 400,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verify Email',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            MyTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: _emailCtrl,
              obscureText: false,
            ),
            const SizedBox(height: 32),
            MyButton(
              text: 'Send Code',
              onTap: (_) => _sendCode(),
              isLoading: _loading,
            ),
          ],
        ),
      ))),
    );
  }
}
