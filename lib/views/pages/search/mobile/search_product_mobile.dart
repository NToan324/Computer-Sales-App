import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/search/widget.dart/search_field.dart';
import 'package:computer_sales_app/views/pages/home/widgets/product_widget.dart';

class SearchProductMobile extends StatefulWidget {
  final Function(String) onSearch;

  const SearchProductMobile({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchProductMobileState createState() => _SearchProductMobileState();
}

class _SearchProductMobileState extends State<SearchProductMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.secondary,
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SearchField(
                      controller: _searchController,
                      autofocus: true,
                      onSubmitted: (query) {
                        widget.onSearch(query);
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Result for \"${_searchController.text}\"",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "1000 founds",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.primary,
                            ),
                          ),                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              
              ProductListViewWidget(), // Nếu nó sử dụng SliverGrid, đặt vào đây
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
