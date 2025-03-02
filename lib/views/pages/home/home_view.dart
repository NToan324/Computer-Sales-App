import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/home/widgets/avatar_widget.dart';
import 'package:computer_sales_app/views/pages/home/widgets/banner_widget.dart';
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
        actions: [AvatarWidget()],
      ),
      body: Padding(
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
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height:
                      20), // 🔹 Khoảng cách giữa Category và danh sách sản phẩm
            ),
            ProductListViewWidget(),
          ],
          // child: Column(
          //   spacing: 20,
          //   children: [
          //     SearchWidget(),
          //     BannerWidget(),
          //     CategoryWidget(),
          //     ProductListViewWidget(),
          //   ],
        ),
      ),
    );
  }
}
