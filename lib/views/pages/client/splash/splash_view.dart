import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/services/user.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/splash/widgets/splash_image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const SplashView());
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final userService = UserService();
  @override
  void initState() {
    super.initState();
    saveUserInProvider();
  }

  Future<void> saveUserInProvider() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userService.loadUserData(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? SplashImageViewWidget()
          : BottomNavigationBarCustom(),
    );
  }
}
