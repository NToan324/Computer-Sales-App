import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class ProductListViewWidget extends StatelessWidget {
  const ProductListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 10,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 350,
      ),
      itemBuilder: (context, index) => ProductView(),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, 'product-details'),
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 150, maxHeight: 350),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: const Color.fromARGB(255, 238, 238, 238),
                ),
                child: Image.asset(
                  'assets/images/laptop.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acer Aspire 5 Slim Laptop',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizes.medium),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.orangePastel,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Ram 8GB',
                          style: TextStyle(
                            fontSize: FontSizes.small,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.orangePastel,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'SSD 512GB',
                          style: TextStyle(
                            fontSize: FontSizes.small,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatMoney(5000000),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        fontSize: FontSizes.medium),
                  ),
                  Wrap(
                    spacing: 5,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.amber,
                          ),
                          Text('4.5'),
                        ],
                      ),
                      Text('23 Reviews'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
