import 'package:computer_sales_app/components/custom/cart.dart';
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
              //Container được dùng khi người dùng chưa đăng nhập
              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       color: AppColors.amber.withAlpha(60)),
              //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //   width: 80,
              //   child: Text(
              //     'Login',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: AppColors.primary,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
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
