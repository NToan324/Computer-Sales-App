import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:computer_sales_app/views/pages/home/home_view.dart';
import 'package:flutter/material.dart';

class SplashImageViewWidget extends StatelessWidget {
  const SplashImageViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: 'assets/images/accessories.png',
      splashIconSize: 300,
      nextScreen: HomeView(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
