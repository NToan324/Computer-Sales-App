import 'package:computer_sales_app/views/pages/client/product_details/widgets/color_version.dart';

import 'package:computer_sales_app/views/pages/client/product_details/widgets/description_product.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/review.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/title_product.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/version_product.dart';
import 'package:flutter/material.dart';

class InformationProduct extends StatelessWidget {
  InformationProduct({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController ?? _scrollController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Reviews(),
        SizedBox(
          height: 15,
        ),
        TitleProduct(),
        SizedBox(
          height: 15,
        ),
        ColorsVersion(),
        SizedBox(
          height: 15,
        ),
        VersionProduct(
          title: 'Surface Pro 7 | i5 8GB - 128GB',
          price: 14900000,
        ),
        SizedBox(
          height: 15,
        ),
        DescriptionProduct(),
      ],
    );
  }
}
