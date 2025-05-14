import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/otp_input.dart';

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  _VerifyOtpViewState createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  bool _isLoading = false; // Thêm trạng thái loading

  Future<void> verifyOtp(BuildContext context) async {
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    String otpCode = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;

    if (otpCode.length < 4) {
      showCustomSnackBar(context, 'Please enter a valid OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = AuthService();
      await auth.verifyOtp(otpCode: otpCode, id: userId);
      // Thêm độ trễ 1 giây để hiển thị hiệu ứng loading
      Navigator.pushNamed(context, 'change-password', arguments: userId);
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
            Navigator.pop(context);
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
                spacing: 20,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/email-verification.png',
                    ),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Enter the 4 digit OTP sent to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159),
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: OtpInput(
                              controller: otp1Controller, autoFocus: true)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp2Controller)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp3Controller)),
                      const SizedBox(width: 20),
                      Flexible(child: OtpInput(controller: otp4Controller)),
                    ],
                  ),
                  MyButton(
                    text: 'Verify OTP',
                    onTap: (_) => verifyOtp(context),
                    isLoading: _isLoading, // Truyền trạng thái loading
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
