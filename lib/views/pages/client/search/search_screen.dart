import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/product_widget.dart';
import 'package:computer_sales_app/views/pages/client/search/widget/search_field.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';

class SearchScreen extends StatefulWidget {
  final List<String> recentSearches;

  const SearchScreen({super.key, required this.recentSearches});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _recentSearches;

  List<ProductModel> _searchResults = [];
  ProductService productService = ProductService();
  bool _isLoading = false;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(widget.recentSearches);
  }

  void _updateSearch(String query) async {
    setState(() {
      searchQuery = query;
      _isLoading = true;
    });

    try {
      final result = await productService.searchProductVariants(name: query);
      setState(() {
        _searchResults = result['data'] as List<ProductModel>;
      });

      // Lưu vào lịch sử tìm kiếm
      if (query.isNotEmpty) {
        _recentSearches.remove(query);
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      }
    } catch (e) {
      // Xử lý lỗi nếu cần
      print("Search error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearAllSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty || searchQuery.isNotEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _recentSearches.map((search) {
          return GestureDetector(
            onTap: () {
              _searchController.text = search;
              _updateSearch(search);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                search,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarMobile(title: "Search", isBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SearchField(
                  controller: _searchController,
                  autofocus: true,
                  onSubmitted: _updateSearch, // Cập nhật từ khóa tìm kiếm
                ),
              ),
              if (_recentSearches.isNotEmpty && searchQuery.isEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: _clearAllSearches,
                        child: Text(
                          "Clear all",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (searchQuery.isEmpty)
                _buildRecentSearches()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Results for "$searchQuery"',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${_searchResults.length} results",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: ProductListForSearch(
                          products: _searchResults, isLoading: _isLoading),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListForSearch extends StatefulWidget {
  final List<ProductModel> products;
  final bool isLoading;

  const ProductListForSearch({
    super.key,
    required this.products,
    required this.isLoading,
  });

  @override
  State<ProductListForSearch> createState() => _ProductListForSearchState();
}

class _ProductListForSearchState extends State<ProductListForSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          itemCount: widget.isLoading ? 10 : widget.products.length,
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
            final variant = !widget.isLoading && index < widget.products.length
                ? widget.products[index]
                : null;

            return widget.isLoading
                ? const Skeleton()
                : ProductView(
                    id: variant?.id ?? '',
                    categoryId: variant?.categoryId ?? '',
                    variantName: variant?.variantName ?? '',
                    images: (variant?.images as List<ProductImage>),
                    price: (variant?.price as double),
                    variantDescription: variant?.variantDescription ??
                        'No description available',
                    averageRating: variant?.averageRating.toString() ?? '0.0',
                  );
          },
        ),
      ],
    );
  }
}
