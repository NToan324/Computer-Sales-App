import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: Scaffold(
      body: WelcomeImageWidget(),
    ),
  ));
}

class WelcomeImageWidget extends StatelessWidget {
  const WelcomeImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        BannerImage(
            width: 165.0,
            height: 400.0,
            imagePath: "assets/images/laptop_banner.jpg"),
        Column(
          spacing: 10,
          children: [
            BannerImage(
                width: 150.0,
                height: 210.0,
                imagePath: "assets/images/headphone_banner.jpg"),
            BannerImage(
                width: 140.0,
                height: 150.0,
                imagePath: "assets/images/keyboard_banner.jpg"),
          ],
        )
      ],
    );
  }
}

class BannerImage extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;

  const BannerImage({
    super.key,
    required this.width,
    required this.height,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
    );
  }
}
