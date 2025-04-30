import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/otp_input.dart';

class VerifyOtpView extends StatelessWidget {
final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  VerifyOtpView({super.key});

  void verifyOtp(BuildContext context) async {
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    String otpCode = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;

    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    try {
      final auth = AuthService();
      await auth.verifyOtp(otpCode: otpCode, id: userId);
      Navigator.pushNamed(context, 'change-password', arguments: userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Enter the 4-digit OTP sent to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Color.fromARGB(255, 159, 159, 159)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: OtpInput(controller: otp1Controller, autoFocus: true)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp2Controller)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp3Controller)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp4Controller)),
                    ],
                  ),
                  const SizedBox(height: 60),
                   MyButton(
                    text: 'Verify OTP',
                    onTap: verifyOtp // <- sửa email => userId
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
