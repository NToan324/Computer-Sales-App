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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildHeaderItem("Home", context, "home"),
          _buildHeaderItem("Products", context, "product-details"),
          _buildHeaderItem("Messages", context, "chat"),
          _buildHeaderItem("Order", context, "chat"),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String label, BuildContext context, [String? route]) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          if (route != null) {
            if (ModalRoute.of(context)?.settings.name != route) {
              Navigator.pushNamed(context, route);
            }
          }
        },
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: ModalRoute.of(context)?.settings.name == route
                  ? AppColors.primary
                  : Colors.black54),
        ),
      ),
    );
  }
}
