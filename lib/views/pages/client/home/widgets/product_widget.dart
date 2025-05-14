import 'dart:ui';

import 'package:computer_sales_app/components/custom/pagination.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(page: 1, limit: 12, resetFilter: true);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.products;
    final totalPage = provider.totalPage;
    final currentPage = provider.page;
    return Column(
      children: [
        GridView.builder(
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
                    variantDescription: variant?.variantDescription ??
                        'No description available',
                    averageRating: variant?.averageRating.toString() ?? '0.0',
                  );
          },
        ),
        SizedBox(
          height: 20,
        ),
        PaginationWidget(
          currentPage: currentPage,
          totalPages: totalPage,
          onPageChanged: (page) {
            provider.fetchProducts(page: page, limit: 12, resetFilter: true);
          },
        ),
        SizedBox(
          height: 20,
        ),
      ],
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

class FilterHomeProduct extends StatefulWidget {
  const FilterHomeProduct({super.key});

  @override
  State<FilterHomeProduct> createState() => _FilterHomeProductState();
}

class _FilterHomeProductState extends State<FilterHomeProduct> {
  final List<String> filtersList = [
    'All',
    'Low to High',
    'High to Low',
  ];

  late String isSelectedList;
  @override
  void initState() {
    super.initState();
    isSelectedList = filtersList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(),
        Text(
          'Product',
          style: TextStyle(
              fontSize: lerpDouble(
                  16, 18, (MediaQuery.of(context).size.width - 300) / 300),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 10),
            scrollDirection: Axis.horizontal,
            itemCount: filtersList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(
                    () {
                      isSelectedList = filtersList[index];
                      final valueFilter = switch (filtersList[index]) {
                        'Low to High' => 'Price: Low to High',
                        'High to Low' => 'Price: High to Low',
                        _ => 'All',
                      };
                      Provider.of<ProductProvider>(context, listen: false)
                          .handleSortChange(valueFilter);
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelectedList == filtersList[index]
                        ? AppColors.orangePastel
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      filtersList[index],
                      style: TextStyle(
                          color: isSelectedList == filtersList[index]
                              ? AppColors.primary
                              : Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
