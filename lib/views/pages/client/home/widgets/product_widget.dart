// import 'package:computer_sales_app/config/color.dart';
// import 'package:computer_sales_app/config/font.dart';
// import 'package:computer_sales_app/helpers/formatMoney.dart';
// import 'package:computer_sales_app/utils/responsive.dart';
// import 'package:flutter/material.dart';

// class ProductListViewWidget extends StatelessWidget {
//   const ProductListViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: 10,
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
//         childAspectRatio: 0.5,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         mainAxisExtent: 350,
//       ),
//       itemBuilder: (context, index) => ProductView(),
//     );
//   }
// }

// class ProductView extends StatelessWidget {
//   const ProductView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => {
//         Navigator.pushNamed(context, 'product-details'),
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ConstrainedBox(
//               constraints: BoxConstraints(minHeight: 150, maxHeight: 350),
//               child: Container(
//                 width: double.infinity,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     topRight: Radius.circular(10),
//                   ),
//                   color: const Color.fromARGB(255, 238, 238, 238),
//                 ),
//                 child: Image.asset(
//                   'assets/images/laptop.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Acer Aspire 5 Slim Laptop',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: FontSizes.medium),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     spacing: 5,
//                     children: [
//                       Flexible(
//                         child: ConstrainedBox(
//                           constraints: const BoxConstraints(
//                             maxWidth: 70, // tối đa 70
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.orangePastel,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               'Ram 8GB',
//                               style: TextStyle(
//                                 fontSize: FontSizes.small,
//                                 color: AppColors.primary,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Flexible(
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(
//                             maxWidth: 90,
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(5),
//                             decoration: BoxDecoration(
//                               color: AppColors.orangePastel,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Text(
//                               'SSD 512GB',
//                               style: TextStyle(
//                                 fontSize: FontSizes.small,
//                                 color: AppColors.primary,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     formatMoney(5000000),
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.secondary,
//                         fontSize: FontSizes.medium),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Row(
//                     spacing: 5,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.star,
//                             size: 15,
//                             color: Colors.amber,
//                           ),
//                           Text('4.5'),
//                         ],
//                       ),
//                       Expanded(
//                         child: Text(
//                           '23 Reviews',
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class ProductListViewWidget extends StatefulWidget {
  const ProductListViewWidget({super.key});

  @override
  State<ProductListViewWidget> createState() => _ProductListViewWidgetState();
}

class _ProductListViewWidgetState extends State<ProductListViewWidget> {
  final ProductService _productService = ProductService();
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await _productService.getVariants();
      setState(() {
        _products = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() => _isLoading = false);
    }
  }

  int _parsePrice(dynamic price) {
    if (price is int) return price;
    if (price is double) return price.toInt();
    if (price is String) return int.tryParse(price) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      itemCount: _products.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 350,
      ),
      itemBuilder: (context, index) {
        final variant = _products[index];

        return ProductView(
          name: variant['variant_name'] ?? '',
          imageUrl: (variant['images'] != null && variant['images'].isNotEmpty)
              ? variant['images'][0]['url'] ?? ''
              : '',
          price: _parsePrice(variant['price']),
          description:
              '${variant['variant_color'] ?? ''} ${variant['variant_description'] ?? ''}',
          rating: (variant['avarage_rating'] is int
                  ? (variant['avarage_rating'] as int).toDouble()
                  : variant['avarage_rating'] ?? 0.0)
              .toString(),
        );
      },
    );
  }
}

class ProductView extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int price;
  final String description;
  final String rating;

  const ProductView({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'product-details'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150, maxHeight: 350),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 238, 238, 238),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.contain)
                    : Image.asset('assets/images/laptop.png',
                        fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizes.medium),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: FontSizes.small,
                        color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatMoney(price.toDouble()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      fontSize: FontSizes.medium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(rating),
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
