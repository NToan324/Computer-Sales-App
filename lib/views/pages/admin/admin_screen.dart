// lib/admin/admin_screen.dart
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
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _selectedMenu = "Dashboard"; // Menu mặc định là Dashboard
  Widget _currentScreen = const DashboardScreen();

  void _onMenuTap(String menu) {
    setState(() {
      _selectedMenu = menu;
      switch (menu) {
        case "Dashboard":
          _currentScreen = const DashboardScreen();
          break;
        case "Product":
          _currentScreen = const ProductManagementScreen();
          break;
        case "Customer":
          _currentScreen = const CustomerScreen();
          break;
        case "Invoice":
          _currentScreen = const InvoiceScreen();
          break;
        case "Coupon":
          _currentScreen = const CouponScreen();
          break;
        case "Support":
          _currentScreen = const SupportScreen();
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
       appBar: Responsive.isMobile(context)
        ? AppBar(
            title: const Text("Admin Panel", style: TextStyle(color: Colors.white),),
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
                Navigator.pop(context); // Đóng Drawer sau khi chọn
              },
            ),
          )
        : null,
        body: Responsive.isDesktop(context)
        ? Row(
            children: [
              // Sidebar bên trái
              CustomSidebar(
                selectedMenu: _selectedMenu,
                onMenuTap: _onMenuTap,
              ),
              // Nội dung chính
              Expanded(
                child: _currentScreen,
              ),
            ],
          )
        : _currentScreen, // Mobile/tablet chỉ hiển thị nội dung chính  
    );
  }
}