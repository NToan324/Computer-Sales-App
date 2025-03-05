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
    'Best Seller': 'assets/icons/laptop.svg',
    'New Arrival': 'assets/icons/laptop.svg',
    'Laptop': 'assets/icons/Category00002.svg',
    'Desktop': 'assets/icons/Category00003.svg',
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
      imageUrl: 'assets/images/laptop.png', // Đảm bảo đường dẫn ảnh đúng
      category: 'Laptop', // Danh mục sản phẩm
    ),
    ProductPromotion(
      name: 'Dell Inspiron 5000',
      description: 'Máy tính bàn hiệu suất cao dành cho công việc.',
      price: 12000000,
      discount: 10,
      imageUrl: 'assets/images/laptop.png', // Đảm bảo đường dẫn ảnh đúng
      category: 'Desktop', // Danh mục sản phẩm
    ),
    ProductPromotion(
      name: 'Logitech Mouse',
      description: 'Chuột Logitech dành cho laptop và máy tính bàn.',
      price: 500000,
      discount: 5,
      imageUrl: 'assets/images/laptop.png', // Đảm bảo đường dẫn ảnh đúng
      category: 'Accessories', // Danh mục phụ kiện
    ),
    ProductPromotion(
      name: 'Dell 24" Monitor',
      description: 'Màn hình Dell với độ phân giải 4K.',
      price: 8000000,
      discount: 20,
      imageUrl: 'assets/images/laptop.png', // Đảm bảo đường dẫn ảnh đúng
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
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       isSeeAll = !isSeeAll;
            //     });
            //   },
            //   child: Text(
            //     isSeeAll ? 'See less' : 'See all',
            //     style: TextStyle(
            //         fontSize: FontSizes.medium,
            //         color: AppColor.primary,
            //         fontWeight: FontWeight.w500),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categoriesIcon.length,
            itemBuilder: (context, index) => ListCategoryWidget(
              isHoverButton: isHoverButton,
              icon: categoriesIcon.values.elementAt(index),
              text: categoriesIcon.keys.elementAt(index),
            ),
          ),
        ),
        Text(
          'Popular',
          style:
              TextStyle(fontSize: FontSizes.large, fontWeight: FontWeight.bold),
        ),

        // GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: Responsive.isDesktop(context) ? 10 : 4,
        //     crossAxisSpacing: 10,
        //     mainAxisSpacing: 10,
        //   ),
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: isSeeAll
        //       ? categoriesImage.length
        //       : Responsive.isDesktop(context)
        //           ? 10
        //           : 4,
        //   itemBuilder: (context, index) => Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Container(
        //         width: Responsive.isDesktop(context) ? 90 : 70,
        //         height: Responsive.isDesktop(context) ? 90 : 70,
        //         decoration: BoxDecoration(
        //           color: BackgroundColor.primary,
        //           shape: BoxShape.circle,
        //         ),
        //         child: Image.asset(
        //           categoriesImage.values.elementAt(index),
        //           fit: BoxFit.cover,
        //           width: 30,
        //           height: 30,
        //         ),
        //       ),
        //       Text(
        //         categoriesImage.keys.elementAt(index),
        //         style: TextStyle(fontSize: FontSizes.small),
        //         maxLines: 1,
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          height: 250,
          child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ProductCardWidget(
                    productsPromotion: productsPromotion[index],
                  ),
              separatorBuilder: (context, index) => SizedBox(width: 20),
              itemCount: productsPromotion.length),
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
    return ElevatedButton(
      onHover: (value) => {
        setState(
          () {
            widget.isHoverButton = value;
          },
        ),
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.orangePastel,
        overlayColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {},
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            widget.icon,
            colorFilter: ColorFilter.mode(AppColor.primary, BlendMode.srcIn),
            width: 30,
          ),
          Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.isHoverButton ? AppColor.primary : AppColor.primary,
            ),
          ),
        ],
      ),
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 350,
        maxWidth: 500,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: BackgroundColor.primary,
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
                    child: Text('${productsPromotion.discount}% off'),
                  ),
                  Text(
                    productsPromotion.name,
                    style: TextStyle(
                        fontSize: FontSizes.large, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.visible,
                  ),
                  Text('From ${productsPromotion.price}'),
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
                Image.asset(productsPromotion.imageUrl,
                    width: 200, height: 200),
              ],
            )
          ],
        ),
      ),
    );
  }
}
