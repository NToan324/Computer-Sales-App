import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/header/header_view.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/avatar_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/location_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          Responsive.isDesktop(context)
              ? Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(children: [
                    SvgPicture.asset(
                      'assets/images/firebase-svgrepo-com.svg',
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      'ELap Commerce',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                )
              : const LocationWidget(),
          Responsive.isDesktop(context)
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeaderView(),
                      // SearchWidget(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      actions: [
        Padding(
          padding: Responsive.isDesktop(context)
              ? EdgeInsets.only(right: 32)
              : EdgeInsets.all(0),
          child: AvatarWidget(),
        ),
      ],
    );
  }
}
