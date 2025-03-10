import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/search/mobile/search_product_mobile.dart';
import 'package:computer_sales_app/views/pages/search/web/search_product_web.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class SearchProductScreen extends StatelessWidget {
  final Function(String) onSearch;

  const SearchProductScreen({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? SearchProductMobile(
            onSearch: onSearch,
          )
        : SearchProductWeb(
            onSearch: onSearch,
          );
  }
}
