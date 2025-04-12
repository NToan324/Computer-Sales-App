import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/description_product.dart';
import 'package:flutter/material.dart';

class InformationProduct extends StatelessWidget {
  const InformationProduct({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
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

class ColorsVersion extends StatelessWidget {
  const ColorsVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Wrap(
          spacing: 10,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.orangePastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.greenPastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.bluePastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.greenPastel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '10% OFF',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.green,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Icon(
              Icons.star,
              color: const Color.fromARGB(255, 255, 208, 0),
            ),
            Text(
              '4.5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '(134) Reviews',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }
}

class TitleProduct extends StatelessWidget {
  const TitleProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          'Surface Pro 7 12.3" Touch-Screen Intel Core i5 8GB Memory 128GB Solid State Drive (Latest Model) Platinum',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            Text(
              formatMoney(15900000),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
              softWrap: true,
            ),
            Text(
              formatMoney(14900000),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              softWrap: true,
            ),
          ],
        )
      ],
    );
  }
}

class VersionProduct extends StatelessWidget {
  const VersionProduct({
    super.key,
    required this.title,
    required this.price,
  });
  final String title;
  final double price;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => {},
          child: Container(
            width: 140,
            height: 80,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orangePastel,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Surface Pro 7 | i5 8GB - 128GB',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  formatMoney(14900000),
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
