import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton(
      {super.key,
      this.imageHeight = 180,
      this.imageWidth = double.infinity,
      this.nameHeight = 20,
      this.nameWidth = double.infinity,
      this.descriptionHeight = 40,
      this.descriptionWidth = double.infinity,
      this.priceHeight = 20,
      this.priceWidth = 150,
      this.ratingHeight = 20,
      this.ratingWidth = 100});
  final double imageHeight;
  final double imageWidth;
  final double nameHeight;
  final double nameWidth;
  final double descriptionHeight;
  final double descriptionWidth;
  final double priceHeight;
  final double priceWidth;
  final double ratingHeight;
  final double ratingWidth;

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

class SkeletonImage extends StatelessWidget {
  const SkeletonImage(
      {super.key, this.imageHeight = 180, this.imageWidth = double.infinity});
  final double imageHeight;
  final double imageWidth;

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
        ],
      ),
    );
  }
}
