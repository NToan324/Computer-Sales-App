import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuTap;

  const CustomSidebar({
    super.key,
    required this.selectedMenu,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Material(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 150, // Chiều cao cố định cho header
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 25,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Nhật Toàn",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          "MANAGER",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildMenuItem(
              icon: Icons.dashboard,
              title: "Dashboard",
              isSelected: selectedMenu == "Dashboard",
              onTap: () => onMenuTap("Dashboard"),
            ),
            const SizedBox(height: 10),
            _buildProductDropdown(),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.person,
              title: "Customer",
              isSelected: selectedMenu == "Customer",
              onTap: () => onMenuTap("Customer"),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.shopping_cart,
              title: "Order",
              isSelected: selectedMenu == "Order",
              onTap: () => onMenuTap("Order"),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.receipt_long,
              title: "Invoice",
              isSelected: selectedMenu == "Invoice",
              onTap: () => onMenuTap("Invoice"),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.local_activity,
              title: "Coupon",
              isSelected: selectedMenu == "Coupon",
              onTap: () => onMenuTap("Coupon"),
            ),
            const SizedBox(height: 10),
            _buildMenuItem(
              icon: Icons.support_agent,
              title: "Support",
              isSelected: selectedMenu == "Support",
              onTap: () => onMenuTap("Support"),
            ),
            const Divider(),
            _buildMenuItem(
              icon: Icons.logout,
              title: "Logout",
              isSelected: selectedMenu == "Logout",
              onTap: () => onMenuTap("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 220,
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            tileColor: isSelected ? Colors.orange : null,
            shape: isSelected
                ? RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), // Bo góc bên trái
                right: Radius.circular(0), // Giữ nguyên bên phải
              ),
            )
                : null,
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 220,
          child: ExpansionTile(
            leading: const Icon(
              Icons.local_offer,
              color: Colors.black54,
            ),
            title: const Text(
              "Product",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(0),
              ),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(0),
              ),
            ),
            children: [
              _buildSubMenuItem(
                title: "Product",
                isSelected: selectedMenu == "Product",
                onTap: () => onMenuTap("Product"),
              ),
              _buildSubMenuItem(
                title: "Product Discount",
                isSelected: selectedMenu == "Product Discount",
                onTap: () => onMenuTap("Product Discount"),
              ),
              _buildSubMenuItem(
                title: "Category",
                isSelected: selectedMenu == "Category",
                onTap: () => onMenuTap("Category"),
              ),
              _buildSubMenuItem(
                title: "Brand",
                isSelected: selectedMenu == "Brand",
                onTap: () => onMenuTap("Brand"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        Icons.list,
        color: isSelected ? Colors.white : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 30), // Thụt vào để hiển thị là mục con
      tileColor: isSelected ? Colors.orange : null,
      shape: isSelected
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(30), // Bo góc bên trái
          right: Radius.circular(0), // Giữ nguyên bên phải
        ),
      )
          : null,
      onTap: onTap,
    );
  }
}