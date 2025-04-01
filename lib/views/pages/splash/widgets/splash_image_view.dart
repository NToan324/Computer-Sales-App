import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashImageViewWidget extends StatelessWidget {
  const SplashImageViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 100,
      splash: Lottie.asset('assets/lotties/splash.json'),
      splashIconSize: 300,
      nextScreen: BottomNavigationBarCustom(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}
