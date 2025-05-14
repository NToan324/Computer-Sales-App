import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:provider/provider.dart';

class ProductListViewWidget extends StatefulWidget {
  const ProductListViewWidget({super.key});

  @override
  State<ProductListViewWidget> createState() => _ProductListViewWidgetState();
}

class _ProductListViewWidgetState extends State<ProductListViewWidget> {
  final ProductService _productService = ProductService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await _productService.getVariants();
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final products = data.map((item) => ProductModel.fromMap(item)).toList();
      if (mounted) {
        setState(() => _isLoading = false);
      }
      productProvider.setProducts(products);
    } on BadRequestException catch (e) {
      if (mounted) {
        showCustomSnackBar(context, e.message, type: SnackBarType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    return GridView.builder(
      itemCount: _isLoading ? 10 : products.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 350,
      ),
      itemBuilder: (context, index) {
        final variant =
            !_isLoading && index < products.length ? products[index] : null;
        return _isLoading
            ? Skeleton()
            : ProductView(
                id: variant?.id ?? '',
                variantName: variant?.variantName ?? '',
                images: (variant?.images as List<ProductImage>),
                price: (variant?.price as double),
                variantDescription:
                    variant?.variantDescription ?? 'No description available',
                averageRating: variant?.averageRating.toString() ?? '0.0',
              );
      },
    );
  }
}

class ProductView extends StatelessWidget {
  final String variantName;
  final List<ProductImage> images;
  final double price;
  final String variantDescription;
  final String averageRating;
  final String id;

  const ProductView({
    super.key,
    required this.id,
    required this.variantName,
    required this.images,
    required this.price,
    required this.variantDescription,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product-details/$id'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150, maxHeight: 350),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                height: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: images[0].url.isNotEmpty
                      ? Image.network(
                          images[0].url,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/laptop.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    variantName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    variantDescription,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    formatMoney(price.toDouble()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      fontSize: FontSizes.medium,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(averageRating),
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
