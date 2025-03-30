import 'package:computer_sales_app/views/pages/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/home/home_view.dart';
import 'package:computer_sales_app/views/pages/login/newpass_view.dart';
import 'package:computer_sales_app/views/pages/login/verifyotp_view.dart';
import 'package:computer_sales_app/views/pages/login/login_view.dart';
import 'package:computer_sales_app/views/pages/product_details/product_details_view.dart';
import 'package:computer_sales_app/views/pages/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/search/search_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
      routes: {
        //Login
        'login': (context) => LoginView(),
        'verify-otp': (context) => VerifyOtpView(),
        'change-password': (context) => CreateNewPasswordView(),
        //Home
        'home': (context) => const HomeView(),
        'product-details': (context) => ProductDetailsView(),

        //Search
        //        //Cart
        'cart': (context) => const CartView()
      },
       onGenerateRoute: (settings) {
        if (settings.name == 'search-product') {
          final args = settings.arguments as String?; // Nhận tham số tìm kiếm
          return MaterialPageRoute(
            builder: (context) => SearchProductScreen(
              onSearch: (query) {},
              initialQuery: args ?? "", // Truyền giá trị tìm kiếm vào SearchProductScreen
            ),
          );
        }
        return null;
      },
    );
  }
}
