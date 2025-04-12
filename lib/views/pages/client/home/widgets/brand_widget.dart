import 'dart:ui';

import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class BrandWidget extends StatefulWidget {
  const BrandWidget({super.key});

  @override
  State<BrandWidget> createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  final List<String> brands = [
    'All',
    'New',
    'Low to High',
    'High to Low',
    'Rate',
  ];

  int isSelectedList = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(),
        Text(
          'Product',
          style: TextStyle(
              fontSize: lerpDouble(
                  16, 18, (MediaQuery.of(context).size.width - 300) / 300),
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 50,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 10),
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(
                    () {
                      isSelectedList = index;
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelectedList == index
                        ? AppColors.orangePastel
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      brands[index],
                      style: TextStyle(
                          color: isSelectedList == index
                              ? AppColors.primary
                              : Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
