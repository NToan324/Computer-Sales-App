import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/home/widgets/avatar_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/location_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class AppBarHomeCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHomeCustom({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: Responsive.isDesktop(context) ? 90 : preferredSize.height,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LocationWidget(),
          Responsive.isDesktop(context)
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SearchWidget(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      actions: [
        AvatarWidget(),
      ],
    );
  }
}
