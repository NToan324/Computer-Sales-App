import 'dart:ui';

import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage(
      {super.key,
      required this.imagesUrl,
      required this.activeIndex,
      required this.onTap});

  final List<String> imagesUrl;
  final int activeIndex;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: imagesUrl.length >= 4
            ? 50
            : MediaQuery.of(context).size.width / imagesUrl.length - 60,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => {onTap(index)},
                        child: Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: activeIndex == index ? 2 : 0,
                            ),
                            image: DecorationImage(
                              image: AssetImage(imagesUrl[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: imagesUrl.length),
            ),
          ),
        ),
      ),
    );
  }
}
