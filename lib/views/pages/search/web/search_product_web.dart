import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/search/widget.dart/search_field.dart';
import 'package:computer_sales_app/views/pages/home/widgets/product_widget.dart';

class SearchProductWeb extends StatefulWidget {
  final Function(String) onSearch;

  const SearchProductWeb({
    super.key,
    required this.onSearch,
  });

  @override
  _SearchProductWebState createState() => _SearchProductWebState();
}

class _SearchProductWebState extends State<SearchProductWeb> {
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
          child: ListView(
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
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ProductListViewWidget(),
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
