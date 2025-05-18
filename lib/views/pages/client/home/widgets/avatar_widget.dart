import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/components/custom/cart.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/routes/app_routes.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarWidget extends StatelessWidget {
   AvatarWidget({
    super.key,
    this.userName,
    this.userId,
  });

  final String? userName;
  final String? userId;

    final List<String> recentSearches = [
    "Macbook",
    "Lenovo",
    "Asus",
    "Chuột không dây",
    "Bàn phím cơ",
    "Màn hình ",
    "Tai nghe Gaming"
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final avatarUrl = userProvider.userModel?.avatar.url;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Responsive.isDesktop(context)
                  ? IconButton(
                      icon: const Icon(
                        FeatherIcons.search,
                        size: 25,
                      ),
                      onPressed: () {
                       Navigator.of(context).pushNamed(
                          AppRoutes.searchProduct,
                          arguments: {'recentSearches': recentSearches},
                        );

                      },
                    )
                  : SizedBox(),
              CartWidget(),
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  _handleMenuSelection(value, context);
                },
                offset: Offset(
                  0,
                  50,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    if (userId != null && Responsive.isDesktop(context))
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.person),
                            SizedBox(width: 8),
                            Text('Profile'),
                          ],
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'home',
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.square_grid_2x2),
                          SizedBox(width: 8),
                          Text('Home'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: userId != null ? 'logout' : 'login',
                      child: Row(
                        children: [
                          Icon(
                            userId != null
                                ? Icons.logout_rounded
                                : CupertinoIcons.arrow_right_circle,
                          ),
                          SizedBox(width: 8),
                          Text(
                            userId != null ? 'Logout' : 'Login',
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                child: CircleAvatar(
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/avatar.jpeg')
                          as ImageProvider,
                  radius: Responsive.isDesktop(context) ? 25 : 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value, BuildContext context) async {
    switch (value) {
      case 'profile':
        Navigator.of(context).pushNamed('profile');
        break;
      case 'home':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarCustom(),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case 'login':
        Navigator.of(context).pushNamed('login');
        break;
      case 'logout':
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        await prefs.remove('user');
        await prefs.remove('cart');
        await prefs.remove('isCartSynced');
        if (context.mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.clearUser();
          showCustomSnackBar(context, 'Sign out successfully',
              type: SnackBarType.success);
        }
        break;
      default:
        break;
    }
  }

  // Hàm hiển thị popup thông báo
  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Bạn có thông báo mới!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
