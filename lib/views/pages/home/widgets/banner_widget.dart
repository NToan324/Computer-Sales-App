import 'package:computer_sales_app/components/ui/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({super.key});

  final List<String> imagesUrl = [
    'assets/images/Banner00001.jpeg',
    'assets/images/Banner00002.jpeg',
    'assets/images/Banner00003.jpeg',
    'assets/images/Banner00004.jpeg',
    'assets/images/Banner00005.jpeg',
    'assets/images/Banner00006.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSliderCustom(imagesUrl: imagesUrl);
  }
}
