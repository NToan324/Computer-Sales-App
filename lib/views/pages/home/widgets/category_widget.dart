import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final Map<String, String> categoriesImage = {
    'Laptop': 'assets/images/laptop.png',
    'Desktop': 'assets/images/pc.png',
    'Monitor': 'assets/images/display.png',
    'Keyboard': 'assets/images/accessories.png',
    'Mouse': 'assets/images/accessories.png',
    'Headset': 'assets/images/accessories.png',
    'Speaker': 'assets/images/laptop.png',
    'Printer': 'assets/images/accessories.png',
    'Scanner': 'assets/images/display.png',
    'Projector': 'assets/images/accessories.png',
  };

  bool isSeeAll = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                  fontSize: FontSizes.large, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isSeeAll = !isSeeAll;
                });
              },
              child: Text(
                isSeeAll ? 'See less' : 'See all',
                style: TextStyle(fontSize: FontSizes.medium),
              ),
            ),
          ],
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isDesktop(context) ? 10 : 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: isSeeAll
              ? categoriesImage.length
              : Responsive.isDesktop(context)
                  ? 10
                  : 4,
          itemBuilder: (context, index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Responsive.isDesktop(context) ? 90 : 70,
                height: Responsive.isDesktop(context) ? 90 : 70,

                decoration: BoxDecoration(
                  color: BackgroundColor.primary,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  categoriesImage.values.elementAt(index),
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
              ),
              Text(
                categoriesImage.keys.elementAt(index),
                style: TextStyle(fontSize: FontSizes.small),
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            runSpacing: 20,
            alignment: WrapAlignment.spaceBetween,
            children: List.generate(
                2,
                (index) => SizedBox(
                      child: ProductCardWidget(),
                    )),
          ),
        )

      ],
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width * 0.48
          : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 250,
      decoration: BoxDecoration(
        color: BackgroundColor.yellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('15% off'),
                ),
                Text(
                  'Macbook Pro. New Arrival',
                  style: TextStyle(
                      fontSize: FontSizes.large, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible,
                ),
                Text('From 10.000.000VND'),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                  child: Text(
                    'Buy now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Image.asset('assets/images/laptop.png', width: 200, height: 200),
            ],
          )
        ],
      ),
    );
  }
}
