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
  String searchQuery = ""; // Trạng thái lưu từ khóa tìm kiếm

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(widget.recentSearches);
  }

  void _updateSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        _recentSearches.remove(query);
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      }
    });
  }

  void _clearAllSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty || searchQuery.isNotEmpty) return const SizedBox();
    return Column(
      children: _recentSearches.map((search) {
        return ListTile(
          title: Text(search),
          onTap: () {
            _searchController.text = search;
            _updateSearch(search);
          },
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              setState(() {
                _recentSearches.remove(search);
              });
            },
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.secondary,
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              controller: _searchController,
              autofocus: true,
              onSubmitted: _updateSearch, // Cập nhật từ khóa tìm kiếm
            ),
          ),
          if (_recentSearches.isNotEmpty && searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: _clearAllSearches,
                    child: Text("Clear all", style: TextStyle(fontSize: 18, color: AppColors.primary)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Results for "$searchQuery"',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '10 Found', // Thay thế bằng số thực tế
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Thêm padding vào ProductListViewWidget
                  child: const ProductListViewWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}