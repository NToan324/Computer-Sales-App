import 'package:computer_sales_app/views/pages/search/mobile/search_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/search/widget.dart/search_field.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/search/web/search_web_view.dart'; // Import overlay mới

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  List<String> _recentSearches = [
    "Laptop gaming",
    "Chuột không dây",
    "Bàn phím cơ",
    "Màn hình 4K",
    "Tai nghe bluetooth"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: Responsive.isDesktop(context)
          ? MainAxisAlignment.start
          : MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: Responsive.isDesktop(context)
              ? 400
              : MediaQuery.of(context).size.width * 0.75,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: SearchField(
              controller: _searchController,
              onTap: () {
                if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
                  // Mobile: Chuyển sang SearchScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchMobile(
                        initialRecentSearches: _recentSearches,
                        onSearch: (query) {},
                      ),
                    ),
                  );
                } else {
                  // Desktop: Hiển thị dropdown qua SearchWebOverlay
                  SearchWeb(
                    context: context,
                    searchController: _searchController,
                    recentSearches: _recentSearches,
                    layerLink: _layerLink,
                  ).showOverlay();
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
