import 'package:computer_sales_app/config/color.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<String> initialRecentSearches;
  final Function(String) onSearch;

  const SearchScreen({
    Key? key,
    this.initialRecentSearches = const [],
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(widget.initialRecentSearches);

    // Thêm dữ liệu giả nếu danh sách ban đầu trống
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

  void _clearAllRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _removeRecentSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: BackgroundColor.secondary,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true, // Automatically focus on the TextField
          decoration: InputDecoration(
            fillColor: BackgroundColor.secondary,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            hintText: 'What are you looking for?',
            labelStyle: const TextStyle(color: Colors.black54),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                FeatherIcons.search,
                size: 30,
                color: AppColor.primary,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primary, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _addRecentSearch(query);
              widget.onSearch(query);
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_recentSearches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAllRecentSearches,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 18,
                        ),
                      
                      ),
                    ),
                  ],
                ),
              ),
            if (_recentSearches.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    final search = _recentSearches[index];
                    return ListTile(
                      leading: const Icon(FeatherIcons.clock),
                      title: Text(search),
                      trailing: IconButton(
                        icon: const Icon(FeatherIcons.x, color: AppColor.primary),
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
              ),
          ],
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