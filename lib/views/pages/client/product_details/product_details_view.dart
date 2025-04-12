import 'package:computer_sales_app/components/ui/slider_product.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/draggable_scroll.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  List<String> images = [
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-mockup.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SliderProductCustom(
            imagesUrl: images,
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButtonCustom(
                  icon: Icons.arrow_back_ios_rounded,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButtonCustom(
                  icon: Icons.share_rounded,
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          DraggableScrollCustom(),
        ],
      ),
    );
  }
}

class IconButtonCustom extends StatelessWidget {
  const IconButtonCustom({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          onPressed();
        },
        icon: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}
