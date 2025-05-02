import 'package:computer_sales_app/views/pages/admin/admin_screen.dart';
import 'package:computer_sales_app/views/pages/client/chat/widgets/chat_view.dart';
import 'package:computer_sales_app/views/pages/client/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/client/home/home_view.dart';
import 'package:computer_sales_app/views/pages/client/login/login_view.dart';
import 'package:computer_sales_app/views/pages/client/login/newpass_view.dart';
import 'package:computer_sales_app/views/pages/client/login/verifyotp_view.dart';
import 'package:computer_sales_app/views/pages/client/notification/notification_view.dart';
import 'package:computer_sales_app/views/pages/client/payment/pament_view.dart';
import 'package:computer_sales_app/views/pages/client/product/product_details_view.dart';
import 'package:computer_sales_app/views/pages/client/product/product_page_view.dart';
import 'package:computer_sales_app/views/pages/client/search/search_product_screen.dart';
import 'package:computer_sales_app/views/pages/client/splash/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: SplashView(),
      routes: {
        //Login
        'login': (context) => LoginView(),
        'verify-otp': (context) => VerifyOtpView(),
        'change-password': (context) => CreateNewPasswordView(),

        //Home
        'home': (context) => HomeView(),
        'product': (context) => ProductPageView(),
        'product-details': (context) => ProductDetailsView(),
        'chat': (context) => ChatView(),
        'notifications': (context) => NotificationView(),
        'payment': (context) => PaymentView(),

        //Search
        'cart': (context) => const CartView(),

        //Admin
        'admin': (context) => const AdminScreen(),
        //Cart
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'search-product') {
          final args = settings.arguments as String?; // Nhận tham số tìm kiếm
          return MaterialPageRoute(
            builder: (context) => SearchProductScreen(
              onSearch: (query) {},
              initialQuery:
                  args ?? "", // Truyền giá trị tìm kiếm vào SearchProductScreen
            ),
          );
        }
        return null;
      },
    );
  }
}
