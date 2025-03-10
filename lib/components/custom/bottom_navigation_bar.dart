import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/home/home_view.dart';
import 'package:computer_sales_app/views/pages/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/order/order_view.dart';
import 'package:computer_sales_app/views/pages/order/widget/appBar_widget.dart';
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
      'page': HomeView(),
      'appBar': AppBarHomeCustom(),
    },
    {
      'page': Text('Notification'),
      'appBar': AppBar(title: Text('Notification')),
    },
    {
      'page': OrderView(),
      'appBar': AppBarOrderCustom(),
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
          size: 25,
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
      'icon': Icons.calendar_today,
      'label': 'Calendar',
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              4,
              (index) => _customItemNavBar(
                    icons[index]['icon'] as IconData,
                    icons[index]['label'] as String,
                    index,
                    currentIndex,
                  )).toList(),
        ),
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
