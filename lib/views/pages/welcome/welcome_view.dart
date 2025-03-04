import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/welcome/widget/sample_image_widget.dart';
import 'package:computer_sales_app/utils/widget/button.dart';
import 'package:computer_sales_app/consts/app_colors.dart';

void main() {
  runApp(const WelcomeView());
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeImageWidget(),
            const Text("An Computer Sales App"),
            const Text("Welcome to the Computer Sales App"),
            SizedBox(
              width: 300,
              child: Button(
                text: "Let's get started",
                onPressed: () {},
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    )));
  }
}
