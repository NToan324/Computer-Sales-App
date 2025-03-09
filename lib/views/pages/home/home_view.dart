import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/home/widgets/avatar_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/banner_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/brand_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/category_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/location_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/product_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/search_widget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Responsive.isDesktop(context) ? 90 : 60,
        titleSpacing: 0,
        centerTitle: Responsive.isDesktop(context) ? true : false,
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
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  spacing: 20,
                  children: [
                    Responsive.isTablet(context) || Responsive.isMobile(context)
                        ? SearchWidget()                        
                        : SizedBox(),
                    BannerWidget(),
                    CategoryWidget(),
                    BrandWidget(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              ProductListViewWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
