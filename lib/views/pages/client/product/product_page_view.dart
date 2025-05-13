import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/product/product_page_body.dart';
import 'package:flutter/material.dart';

class ProductPageView extends StatelessWidget {
  const ProductPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHomeCustom(),
      body: ProductPageBody(),
    );
  }
}
