import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});
  final double imageHeight = 180;
  final double imageWidth = double.infinity;
  final double nameHeight = 20;
  final double nameWidth = double.infinity;
  final double descriptionHeight = 40;
  final double descriptionWidth = double.infinity;
  final double priceHeight = 20;
  final double priceWidth = 150;
  final double ratingHeight = 20;
  final double ratingWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 238, 238, 238),
      highlightColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
          Container(
            height: imageHeight,
            width: imageWidth,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
          //Name
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: nameHeight,
            width: nameWidth,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
          //Description
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: descriptionHeight,
            width: descriptionWidth,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
          //Price
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: priceHeight,
            width: priceWidth,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
          //Rating
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: ratingHeight,
            width: ratingWidth,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
        ],
      ),
    );
  }
}
