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
      // Gọi API forgotPassword để gửi OTP tới email
      final otpData = await auth.forgotPassword(widget.userId);
      final userId = otpData as String;
      // Điều hướng đến trang nhập OTP với userId
      Navigator.pushNamed(context, 'verify-otp', arguments: userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Send code failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      leading: BackButton(color: Colors.black),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Verify Email', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
            onTap: _loading ? null : (_) => _sendCode(),
          ),
        ],
      ),
    ),
  );
}
