import 'package:computer_sales_app/views/pages/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/home/home_view.dart';
import 'package:computer_sales_app/views/pages/login/newpass_view.dart';
import 'package:computer_sales_app/views/pages/login/verifyotp_view.dart';
import 'package:computer_sales_app/views/pages/login/login_view.dart';
import 'package:computer_sales_app/views/pages/product_details/product_details_view.dart';
import 'package:computer_sales_app/views/pages/search/mobile/search_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/search/search_product_screen.dart';
import 'package:computer_sales_app/views/pages/order/order_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
      routes: {
        //Login
        'login': (context) => LoginView(),
        'verify-otp': (context) => VerifyOtpView(),
        'change-password': (context) => CreateNewPasswordView(),
        //Home
        'home': (context) => const HomeView(),
        'product-details': (context) => const ProductDetailsView(),
        'search-product': (context) => SearchProductScreen(onSearch: (query) {
          print('Search query: $query');
        }),
        //Search
        'search': (context) => SearchMobile(onSearch: (query) {
          print('Search query: $query');
        }),
        //Order
        'order': (context) => OrderScreen(),
        //Cart
        'cart': (context) => const CartView()
      },
    );
  }
}
