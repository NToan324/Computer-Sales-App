import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/config/icon.dart';
import 'package:computer_sales_app/helpers/text_helper.dart';
import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.secondary,
                size: IconSize.large,
              ),
              Text(
                TextHelper.textLimit('District 7, Ho Chi Minh City', 30),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: FontSizes.medium,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
