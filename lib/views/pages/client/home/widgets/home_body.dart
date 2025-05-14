import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/footer.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/banner_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/brand_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/category_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/product_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/search_widget.dart';

import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    // Get the user data from provider

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: !Responsive.isMobile(context)
                ? EdgeInsets.only(top: 16, left: 64, right: 64)
                : EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                Responsive.isTablet(context) || Responsive.isMobile(context)
                    ? SearchWidget()
                    : SizedBox(),
                BannerWidget(),
                CategoryWidget(),
                SizedBox(
                  height: 16,
                ),
                FilterHomeProduct(),
                SizedBox(
                  height: 16,
                ),
                ProductListViewWidget(),
              ],
            ),
          ),
          if (Responsive.isDesktop(context)) FooterWidget(),
        ],
      ),
    );
  }
}
