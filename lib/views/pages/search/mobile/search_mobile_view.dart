import 'package:computer_sales_app/utils/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/search/widget.dart/search_field.dart';
import 'package:feather_icons/feather_icons.dart';

class SearchMobile extends StatefulWidget {
  final List<String> initialRecentSearches;
  final Function(String) onSearch;

  const SearchMobile({
    super.key,
    this.initialRecentSearches = const [],
    required this.onSearch,
  });

  @override
  _SearchMobileState createState() => _SearchMobileState();
}

class _SearchMobileState extends State<SearchMobile> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(widget.initialRecentSearches);

    if (_recentSearches.isEmpty) {
      _recentSearches.addAll([
        "Laptop gaming",
        "Chuột không dây",
        "Bàn phím cơ",
        "Màn hình 4K",
        "Tai nghe bluetooth"
      ]);
    }
  }

  void _addRecentSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });
  }

  void _removeRecentSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
  }

  void _clearAllSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor.secondary,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              autofocus: true,
              controller: _searchController,
              onSubmitted: (query) {
                _addRecentSearch(query);
                widget.onSearch(query);
                Navigator.pop(context);
              },
            ),
          ),
          if (_recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAllSearches,
                    child: Text(
                      "Clear all",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
          const SizedBox(height: 10),
          _buildRecentSearches(),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Expanded(
      child: ListView.builder(
        itemCount: _recentSearches.length,
        itemBuilder: (context, index) {
          final search = _recentSearches[index];
          return ListTile(
            leading: const Icon(FeatherIcons.clock),
            title: Text(search),
            trailing: IconButton(
              icon: const Icon(FeatherIcons.x, color: AppColors.primary),
              onPressed: () => _removeRecentSearch(search),
            ),
            onTap: () {
              _searchController.text = search;
              widget.onSearch(search);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
