import 'package:computer_sales_app/provider/brand_provider.dart';
import 'package:computer_sales_app/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/provider/coupon_provider.dart';
import 'package:computer_sales_app/routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
