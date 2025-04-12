import 'package:computer_sales_app/views/pages/product_details/widgets/information_product.dart';
import 'package:flutter/material.dart';

class DraggableScrollCustom extends StatelessWidget {
  const DraggableScrollCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: InformationProduct(
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}
