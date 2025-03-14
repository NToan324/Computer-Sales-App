import 'package:computer_sales_app/components/custom/cart.dart';
import 'package:computer_sales_app/utils/responsive.dart';
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
