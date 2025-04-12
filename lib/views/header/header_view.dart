import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              _buildHeaderItem("Home"),
              _buildHeaderItem("Products"),
              _buildHeaderItem("Deals"),
              _buildHeaderItem("Cart"),
              _buildHeaderItem("Profile"),
            ],
          ),
        ],
      ),
    );
  }

  // Widget tạo từng mục trong header
  Widget _buildHeaderItem(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {},
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: label == 'Home' ? AppColors.primary : Colors.black54),
        ),
      ),
    );
  }
}
