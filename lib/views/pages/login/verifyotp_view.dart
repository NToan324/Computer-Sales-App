import 'package:computer_sales_app/views/pages/login/newpass_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/login/widgets/button.dart';
import 'widgets/otp_input.dart';

class VerifyOtpView extends StatelessWidget {
  VerifyOtpView({Key? key}) : super(key: key);

  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  void verifyOtp() {
    String otpCode = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;
    print("OTP Entered: $otpCode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 400,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Enter the 4-digit OTP sent to your email',
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
                  color: Color.fromARGB(255, 159, 159, 159),
                ),
                const SizedBox(height: 40),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OtpInput(controller: otp1Controller, autoFocus: true),
                    SizedBox(width: 20),
                    OtpInput(controller: otp2Controller),
                    SizedBox(width: 20),
                    OtpInput(controller: otp3Controller),
                    SizedBox(width: 20),
                    OtpInput(controller: otp4Controller),
                  ],
                ),
                const SizedBox(height: 60),
                MyButton(
                  text: 'Verify OTP',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPasswordView())
                    );
                  }
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
