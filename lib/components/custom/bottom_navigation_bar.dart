import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/Chat/widgets/chat_body.dart';
import 'package:computer_sales_app/views/pages/client/Chat/widgets/chat_appbar.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/home_body.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/notification/notification_view.dart';
import 'package:computer_sales_app/views/pages/client/order/order_view.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/appBar_widget.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarCustom extends StatefulWidget {
  const BottomNavigationBarCustom({super.key});

  @override
  State<BottomNavigationBarCustom> createState() =>
      _BottomNavigationBarCustomState();
}

class _BottomNavigationBarCustomState extends State<BottomNavigationBarCustom> {
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final List<Map<String, dynamic>> _pages = [
    {
      'page': HomeBody(),
      'appBar': AppBarHomeCustom(),
    },
    {
      'page': NotificationView(),
      'appBar': CustomAppBarMobile(title: 'Notification'),
    },
    {
      'page': OrderView(),
      'appBar': AppBarOrderCustom(),
    },
    {
      'page': ChatBody(),
      'appBar': ChatAppBar(),
    },
    {
      'page': Text('Profile'),
      'appBar': AppBar(title: Text('Profile')),
    },
  ];

  Widget _customItemNavBar(
      IconData iconData, String label, int index, int currentIndex) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: currentIndex == index ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          size: 26,
        ),
        color: currentIndex == index ? AppColors.white : Colors.black,
        onPressed: () {
          _currentPage.value = index;
        },
      ),
    );
  }

  final List<Map<String, dynamic>> icons = [
    {
      'icon': Icons.home_outlined,
      'label': 'Home',
    },
    {
      'icon': Icons.notifications_none_outlined,
      'label': 'Notification',
    },
    {
      'icon': Icons.add_to_photos_outlined,
      'label': 'Calendar',
    },
    {
      'icon': FeatherIcons.messageCircle,
      'label': 'Message',
    },
    {
      'icon': Icons.person_outline_rounded,
      'label': 'Profile',
    },
  ];

  Scaffold _buildPage(int currentIndex) {
    return Scaffold(
      appBar: _pages[currentIndex]['appBar'] as PreferredSizeWidget,
      body: _pages[currentIndex]['page'] as Widget,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Responsive.isMobile(context)
            ? BottomAppBar(
                color: Colors.white,
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      5,
                      (index) => _customItemNavBar(
                            icons[index]['icon'] as IconData,
                            icons[index]['label'] as String,
                            index,
                            currentIndex,
                          )).toList(),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (context, currentIndex, child) {
        return currentIndex == 2
            ? DefaultTabController(
                length: 3,
                child: _buildPage(currentIndex),
              )
            : _buildPage(currentIndex);
      },
    );
  }
}
