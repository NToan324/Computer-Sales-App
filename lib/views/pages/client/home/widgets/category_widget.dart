import 'dart:ui';

import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/models/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final Map<String, String> categoriesIcon = {
    'All': 'assets/icons/Category00008.svg',
    'Deals': 'assets/icons/Category00001.svg',
    'Laptop': 'assets/icons/Category00002.svg',
    'Best Seller': 'assets/icons/laptop.svg',
    'Desktop': 'assets/icons/Category00003.svg',
    'New Arrival': 'assets/icons/laptop.svg',
    'Monitor': 'assets/icons/Category00004.svg',
    'Mouse': 'assets/icons/Category00006.svg',
    'Headphone': 'assets/icons/Category00007.svg',
    'Keyboard': 'assets/icons/Category00005.svg',
  };

  final List<ProductPromotion> productsPromotion = [
    ProductPromotion(
      name: 'Macbook Pro',
      description: 'Laptop mới nhất với hiệu năng vượt trội.',
      price: 10000000,
      discount: 15,
      imageUrl:
          'assets/images/laptop-popular-1.jpg', // Đảm bảo đường dẫn ảnh đúng
      category: 'Laptop', // Danh mục sản phẩm
    ),
    ProductPromotion(
      name: 'Dell Inspiron 5000',
      description: 'Máy tính bàn hiệu suất cao dành cho công việc.',
      price: 12000000,
      discount: 10,
      imageUrl:
          'assets/images/laptop-popular-2.jpg', // Đảm bảo đường dẫn ảnh đúng
      category: 'Desktop', // Danh mục sản phẩm
    ),
    ProductPromotion(
      name: 'Logitech Mouse',
      description: 'Chuột Logitech dành cho laptop và máy tính bàn.',
      price: 500000,
      discount: 5,
      imageUrl:
          'assets/images/laptop-popular-1.jpg', // Đảm bảo đường dẫn ảnh đúng
      category: 'Accessories', // Danh mục phụ kiện
    ),
    ProductPromotion(
      name: 'Dell 24" Monitor',
      description: 'Màn hình Dell với độ phân giải 4K.',
      price: 8000000,
      discount: 20,
      imageUrl:
          'assets/images/laptop-popular-1.jpg', // Đảm bảo đường dẫn ảnh đúng
      category: 'Accessories', // Danh mục phụ kiện
    ),
  ];

  bool isSeeAll = false;
  bool isHoverButton = false;
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
            TextButton(
              onPressed: () {
                setState(() {
                  isSeeAll = !isSeeAll;
                });
              },
              child: Text(
                isSeeAll ? 'See less' : 'See all',
                style: TextStyle(
                  color: Colors.black.withAlpha(100),
                ),
              ),
            ),
          ],
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: isSeeAll ? categoriesIcon.length : 4,
          itemBuilder: (context, index) => ListCategoryWidget(
            isHoverButton: isHoverButton,
            icon: categoriesIcon.values.elementAt(index),
            text: categoriesIcon.keys.elementAt(index),
          ),
        ),
        Text(
          'Popular',
          style:
              TextStyle(fontSize: FontSizes.large, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 270,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ProductCardWidget(
              productsPromotion: productsPromotion[index],
            ),
            separatorBuilder: (context, index) => SizedBox(width: 30),
            itemCount: productsPromotion.length,
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class ListCategoryWidget extends StatefulWidget {
  ListCategoryWidget({
    super.key,
    required this.isHoverButton,
    required this.icon,
    required this.text,
  });

  late bool isHoverButton;
  final String icon;
  final String text;

  @override
  State<ListCategoryWidget> createState() => _ListCategoryWidgetState();
}

class _ListCategoryWidgetState extends State<ListCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color:
                widget.isHoverButton ? AppColors.orangePastel : AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SvgPicture.asset(
            widget.icon,
            colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            width: 30,
          ),
        ),
        Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: widget.isHoverButton ? AppColors.primary : Colors.black,
          ),
        ),
      ],
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.productsPromotion,
  });

  final ProductPromotion productsPromotion;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 280,
            maxWidth: 280,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: BackgroundColor.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: Offset(10, 10),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(productsPromotion.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 10,
          left: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(130),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productsPromotion.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('From ${productsPromotion.price}'),
                        Text('${productsPromotion.discount}% off'),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
