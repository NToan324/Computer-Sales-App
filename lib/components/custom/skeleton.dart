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

class SkeletonHorizontalProduct extends StatelessWidget {
  const SkeletonHorizontalProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 238, 238, 238),
      highlightColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin: title, description, quantity + price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 238, 238, 238),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Container(
                    height: 16,
                    width: 250,
                    color: const Color.fromARGB(255, 238, 238, 238),
                  ),
                  const SizedBox(height: 12),

                  // Quantity + Price
                  Row(
                    children: [
                      // Quantity
                      Container(
                        height: 20,
                        width: 60,
                        color: const Color.fromARGB(255, 238, 238, 238),
                      ),
                      const SizedBox(width: 16),
                      // Price
                      Container(
                        height: 20,
                        width: 100,
                        color: const Color.fromARGB(255, 238, 238, 238),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonCategoryItem extends StatelessWidget {
  const SkeletonCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 238, 238, 238),
      highlightColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vòng tròn biểu tượng
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 238, 238, 238),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Văn bản tên danh mục
          Container(
            height: 14,
            width: 40,
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
        ],
      ),
    );
  }
}
