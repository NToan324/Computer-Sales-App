import 'package:computer_sales_app/components/custom/myTextField.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';

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
      showCustomSnackBar(context, 'Please enter your email');
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = AuthService();
      final otpData = await auth.forgotPassword(email);
      final userId = otpData['id'];
      // Thêm độ trễ 1 giây để hiển thị hiệu ứng loading
      await Future.delayed(const Duration(milliseconds: 1000));
      showCustomSnackBar(context, 'Code sent to your email',
          type: SnackBarType.success);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, 'verify-otp', arguments: userId);
      });
    } on BadRequestException catch (e) {
      showCustomSnackBar(context, e.message);
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 255, 238, 212),
              ),
              child: Image(
                image: AssetImage(
                  'assets/images/email.png',
                ),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const Text(
              'Verify Email',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 300,
              child: const Text(
                'Please enter your email to receive a verification code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            MyTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: _emailCtrl,
              obscureText: false,
            ),
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
