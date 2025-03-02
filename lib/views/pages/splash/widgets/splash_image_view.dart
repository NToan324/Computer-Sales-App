import 'package:flutter/material.dart';

class SplashImageViewWidget extends StatelessWidget {
  const SplashImageViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/icons/icon_splash.png"),
    );
  }
}
