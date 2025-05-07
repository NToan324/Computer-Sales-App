import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/dashboard_screen.dart';
import 'package:computer_sales_app/views/pages/admin/customer/customer_screen.dart';
import 'package:computer_sales_app/views/pages/admin/invoice/invoice_screen.dart';
import 'package:computer_sales_app/views/pages/admin/product/product_screen.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/coupon_screen.dart';
import 'package:computer_sales_app/views/pages/admin/support/support_screen.dart';
import 'package:computer_sales_app/components/custom/sidebar.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _selectedMenu = "Dashboard";
  Widget _currentScreen = const DashboardScreen();
  bool _hideAppBar = false; // Trạng thái để ẩn AppBar trên mobile

  void _onMenuTap(String menu) {
    setState(() {
      _selectedMenu = menu;
      _hideAppBar = false; // Reset trạng thái khi chuyển menu
      switch (menu) {
        case "Dashboard":
          _currentScreen = const DashboardScreen();
          break;
        case "Product":
          _currentScreen = const ProductManagementScreen();
          break;
        case "Customer":
          _currentScreen = CustomerManagementScreen();
          break;
        case "Invoice":
          _currentScreen = const InvoiceManagementScreen();
          break;
        case "Coupon":
          _currentScreen = CouponManagementScreen();
          break;
        case "Support":
          _currentScreen = SupportScreen(
            onChatAreaVisibilityChanged: (isVisible) {
              setState(() {
                _hideAppBar = isVisible;
              });
            },
          );
          break;
        case "Logout":
          Navigator.pushReplacementNamed(context, 'login');
          return;
        default:
          _currentScreen = const DashboardScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: Responsive.isMobile(context) && !_hideAppBar
          ? AppBar(
              title: const Text(
                "Admin Panel",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      drawer: Responsive.isMobile(context)
          ? Drawer(
              width: 250,
              child: CustomSidebar(
                selectedMenu: _selectedMenu,
                onMenuTap: (menu) {
                  _onMenuTap(menu);
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Responsive.isDesktop(context)
          ? Row(
              children: [
                CustomSidebar(
                  selectedMenu: _selectedMenu,
                  onMenuTap: _onMenuTap,
                ),
                Expanded(
                  child: _currentScreen,
                ),
              ],
            )
          : _currentScreen,
    );
  }
}