import 'package:computer_sales_app/views/pages/client/splash/widgets/splash_image_view.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const SplashView());
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashImageViewWidget(),
    );
  }
}
