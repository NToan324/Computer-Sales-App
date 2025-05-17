import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/admin/brand/brand_screen.dart';
import 'package:computer_sales_app/views/pages/admin/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/dashboard_screen.dart';
import 'package:computer_sales_app/views/pages/admin/customer/customer_screen.dart';
import 'package:computer_sales_app/views/pages/admin/order/order_screen.dart';
import 'package:computer_sales_app/views/pages/admin/invoice/invoice_screen.dart';
import 'package:computer_sales_app/views/pages/admin/product/product_screen.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/coupon_screen.dart';
import 'package:computer_sales_app/views/pages/admin/support/support_screen.dart';
import 'package:computer_sales_app/components/custom/sidebar.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _selectedMenu = "Dashboard";
  Widget _currentScreen = const DashboardScreen();
  bool _hideAppBar = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'login');
      }
    }
  }
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user');
    if (mounted) {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
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
        case "Category":
          _currentScreen = CategoryManagementScreen();
        case "Brand":
          _currentScreen = BrandManagementScreen();
        case "Customer":
          _currentScreen = CustomerManagementScreen();
          break;
        case "Order":
          _currentScreen = const OrderManagementScreen();
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
          _logout();
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
