import 'package:computer_sales_app/views/pages/home/widgets/appBar_widget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/home/widgets/product_widget.dart';

class SearchProductScreen extends StatefulWidget {
  final Function(String) onSearch;
  final String initialQuery;

  const SearchProductScreen({
    super.key,
    required this.onSearch,
    required this.initialQuery,
  });

  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.secondary,
      appBar: AppBarHomeCustom(),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Thêm ô nhập tìm kiếm

              const SizedBox(height: 10),
              
              // Hiển thị lịch sử tìm kiếm gần đây
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          "Result for \"${_searchController.text}\"",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      "1000 founds",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Danh sách sản phẩm tìm thấy
              Expanded(
                child: SingleChildScrollView(
                  child: ProductListViewWidget()
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
