import 'package:computer_sales_app/models/brand.model.dart';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Khởi tạo Hive
  await Hive.initFlutter();

  // Đăng ký adapter cho model Hive
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(ProductImageAdapter());

  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(CategoryImageAdapter());

  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(BrandImageAdapter());

  // Mở box lưu trữ dữ liệu products
  await Hive.openBox<ProductModel>('productsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
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
