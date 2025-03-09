import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';

class SearchWeb {
  final BuildContext context;
  final TextEditingController searchController;
  final List<String> recentSearches;
  final LayerLink layerLink; // Nhận LayerLink từ SearchWidget
  OverlayEntry? _overlayEntry;

  SearchWeb({
    required this.context,
    required this.searchController,
    required this.recentSearches,
    required this.layerLink, // Thêm LayerLink vào constructor
  });

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 400,
        child: CompositedTransformFollower(
          link: layerLink, // Sử dụng LayerLink từ SearchWidget
          offset: const Offset(0, 50),
          child: Material(
            type: MaterialType.card,
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            color: BackgroundColor.secondary,
            child: _buildRecentSearches(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildRecentSearches() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BackgroundColor.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: recentSearches
            .map((search) => ListTile(
                  title: Text(search),
                  onTap: () {
                    searchController.text = search;
                    _removeOverlay();
                  },
                ))
            .toList(),
      ),
    );
  }
}
