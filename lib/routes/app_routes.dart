import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/views/pages/client/order/order_view.dart';
import 'package:computer_sales_app/views/pages/client/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/admin_screen.dart';
import 'package:computer_sales_app/views/pages/client/chat/widgets/chat_view.dart';
import 'package:computer_sales_app/views/pages/client/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/client/login/login_view.dart';
import 'package:computer_sales_app/views/pages/client/login/newpass_view.dart';
import 'package:computer_sales_app/views/pages/client/login/verifyotp_view.dart';
import 'package:computer_sales_app/views/pages/client/payment/pament_view.dart';
import 'package:computer_sales_app/views/pages/client/product/product_details_view.dart';
import 'package:computer_sales_app/views/pages/client/product/product_page_view.dart';
import 'package:computer_sales_app/views/pages/client/profile/profile_view.dart';
import 'package:computer_sales_app/views/pages/client/splash/splash_view.dart';
import 'package:computer_sales_app/views/pages/client/voucher/voucher_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = 'login';
  static const String verifyOtp = 'verify-otp';
  static const String changePassword = 'change-password';
  static const String home = 'home';
  static const String product = 'product';
  static const String productDetails = 'product-details';
  static const String chat = 'chat';
  static const String payment = 'payment';
  static const String voucher = 'voucher';
  static const String profile = 'profile';
  static const String cart = 'cart';
  static const String admin = 'admin';
  static const String searchProduct = 'search';
  static const String orderView = 'order-view';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashView(),
    login: (context) => LoginView(),
    verifyOtp: (context) => VerifyOtpView(),
    changePassword: (context) => CreateNewPasswordView(),
    home: (context) => BottomNavigationBarCustom(),
    product: (context) => ProductPageView(),
    orderView: (context) => OrderView(),
    productDetails: (context) => ProductDetailsView(
          productId: '',
          categoryId: '',
        ),
    chat: (context) => ChatView(),
    payment: (context) => PaymentView(),
    voucher: (context) => VoucherView(),
    profile: (context) => const ProfileView(),
    cart: (context) => const CartView(),
    admin: (context) => const AdminScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name != null &&
        settings.name!.startsWith('/product-details/')) {
      final id = settings.name!.split('/').last;

      final args = settings.arguments as Map<String, dynamic>?;

      return MaterialPageRoute(
        builder: (context) => ProductDetailsView(
          productId: id,
          categoryId: args?['categoryId'], // Lấy categoryId từ arguments
        ),
      );
    }

    if (settings.name == searchProduct) {
      final args = settings.arguments as Map<String, dynamic>?;
      final recentSearches = args?['recentSearches'] ?? <String>[];

      return MaterialPageRoute(
        builder: (context) => SearchScreen(recentSearches: recentSearches),
      );
    }

    return null;
  }
}
