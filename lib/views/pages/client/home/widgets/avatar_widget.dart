import 'package:computer_sales_app/components/custom/cart.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.userName,
    this.userId,
  });

  final String? userName;
  final String? userId;
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {},
                    )
                  : SizedBox(),
              CartWidget(),
              // Sử dụng PopupMenuButton để hiển thị menu khi nhấp vào avatar
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  _handleMenuSelection(value, context);
                },
                offset: Offset(
                    0, 50), // Điều chỉnh vị trí của menu (dịch xuống dưới)
                itemBuilder: (BuildContext context) {
                  return [
                    if (userId != null)
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
                      value: 'notifications',
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.bell),
                          SizedBox(width: 8),
                          Text('Notifications'),
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
                  backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                  radius: Responsive.isDesktop(context) ? 25 : 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Xử lý sự kiện khi người dùng chọn một tùy chọn trong menu
  void _handleMenuSelection(String value, BuildContext context) async {
    switch (value) {
      case 'profile':
        // Điều hướng đến trang thông tin cá nhân
        break;
      case 'notifications':
        if (Responsive.isDesktop(context)) {
          _showNotificationPopup(context);
        }
        // Điều hướng đến trang thông báo
        break;
      case 'login':
        Navigator.of(context).pushNamed('login');
        // Điều hướng đến trang đăng nhập
        break;
      case 'logout':
        // Xử lý đăng xuất
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('user');
        // Xóa thông tin người dùng khỏi provider
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
