// TODO Implement this library.
import "package:computer_sales_app/views/pages/login/verifyotp_view.dart";
import "package:computer_sales_app/views/pages/login/widgets/text_field.dart";
import "package:flutter/material.dart";
import 'widgets/button.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({Key? key}) : super(key: key);
  final userNameController = TextEditingController();

  //Sign user in method
  void sendCode() {
    print('Sendcode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang Login
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify email',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please enter email to send otp code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 159, 159, 159),
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
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: userNameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 60),
                  MyButton(
                      text: 'Send code',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyOtpView())
                        );
                      }
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
