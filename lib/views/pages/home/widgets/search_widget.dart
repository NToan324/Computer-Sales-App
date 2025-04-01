import 'package:computer_sales_app/views/pages/search/search_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/search/search_screen.dart';
import 'package:computer_sales_app/views/pages/search/widget/search_field.dart';
import 'package:computer_sales_app/config/color.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    "Laptop gaming",
    "Chuột không dây",
    "Bàn phím cơ",
    "Màn hình 4K",
    "Tai nghe bluetooth"
  ];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _openSearchScreen({String? query}) {
    // Nếu đang ở chế độ desktop
    if (Responsive.isDesktop(context)) {
      if (query != null && query.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchProductScreen(
              onSearch: (newQuery) {}, // Có thể thêm logic cập nhật nếu cần
              initialQuery: query,
            ),
          ),
        );
      } else {
        // Nếu không có từ khóa => Mở danh sách tìm kiếm gần đây
        _showOverlay();
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(recentSearches: _recentSearches),
        ),
      );
    }
  }

  void _showOverlay() {
    _removeOverlay(); // Đóng overlay cũ nếu có
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque, // Bắt sự kiện click ngoài overlay
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
                    color: Colors.transparent)), // Click ngoài để đóng
            Positioned(
              width: 400,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, 50), // Hiển thị ngay dưới ô tìm kiếm
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_recentSearches.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: _clearAllSearches,
                                  child: Text("Clear all",
                                      style:
                                          TextStyle(color: AppColors.primary)),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                        ..._recentSearches.map((search) {
                          return ListTile(
                            title: Text(search),
                            onTap: () {
                              _searchController.text = search;
                              _removeOverlay();
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () => _removeRecentSearch(search),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _clearAllSearches() {
    setState(() {
      _recentSearches.clear();
    });
    _removeOverlay();
    _showOverlay();
  }

  void _removeRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
    _removeOverlay();
    _showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        mainAxisAlignment: Responsive.isDesktop(context)
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Responsive.isDesktop(context)
                ? 400
                : MediaQuery.of(context).size.width * 0.75,
            child: SearchField(
              controller: _searchController,
              onTap: () => {
                if (Responsive.isDesktop(context))
                  {_showOverlay()}
                else
                  {_openSearchScreen()}
              },
              onSubmitted: (query) {
                _searchController.text = query;
                _openSearchScreen(query: query);
              },
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
