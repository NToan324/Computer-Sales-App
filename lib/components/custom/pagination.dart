import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int page) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<Widget> _buildPageNumbers() {
    List<Widget> widgets = [];

    if (totalPages <= 3) {
      // Hiển thị tất cả các trang nếu tổng ≤ 3
      for (int i = 1; i <= totalPages; i++) {
        widgets.add(_buildPageButton(i));
      }
    } else {
      // Luôn hiển thị trang 1
      widgets.add(_buildPageButton(1));

      if (currentPage <= 2) {
        // 1 2 ... last
        widgets.add(_buildPageButton(2));
        widgets.add(_ellipsis());
      } else if (currentPage >= totalPages - 1) {
        // 1 ... n-1 n
        widgets.add(_ellipsis());
        widgets.add(_buildPageButton(totalPages - 1));
      } else {
        // 1 ... current ... last
        widgets.add(_ellipsis());
        widgets.add(_buildPageButton(currentPage));
        widgets.add(_ellipsis());
      }

      // Luôn hiển thị trang cuối nếu chưa hiển thị
      widgets.add(_buildPageButton(totalPages));
    }

    return widgets;
  }

  Widget _buildPageButton(int page) {
    final isActive = page == currentPage;
    return SizedBox(
      width: 40,
      child: TextButton(
        onPressed: () => onPageChanged(page),
        style: TextButton.styleFrom(
          foregroundColor: isActive ? Colors.white : Colors.black,
          backgroundColor: isActive ? AppColors.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('$page'),
      ),
    );
  }

  Widget _ellipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('...', style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        ..._buildPageNumbers(),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
