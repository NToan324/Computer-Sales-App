import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FeatherIcons.shoppingCart,
                  color: AppColor.primary,
                  size: 30,
                ),
              ),
              Container(
                width: Responsive.isDesktop(context) ? 50 : 40,
                height: Responsive.isDesktop(context) ? 50 : 40,
                decoration: BoxDecoration(
                    color: AppColor.primary, shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/avatar.jpeg',
                ),
                radius: Responsive.isDesktop(context) ? 25 : 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}
