import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class TextFieldReviewWidget extends StatelessWidget {
  const TextFieldReviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: ShapeBorder.lerp(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.grey)),
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.grey)),
            0.5),
        color: AppColors.white,
        child: Container(
          width: Responsive.isMobile(context)
              ? MediaQuery.sizeOf(context).width * 0.9
              : MediaQuery.sizeOf(context).width * 0.7,
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            decoration:
                InputDecoration.collapsed(hintText: "Write your review here"),
          ),
        ));
  }
}
