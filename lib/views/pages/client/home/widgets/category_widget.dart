import 'dart:ui';

import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/category.model.dart';
import 'package:computer_sales_app/models/product_card.model.dart';
import 'package:computer_sales_app/provider/product_provider.dart';
import 'package:computer_sales_app/services/app_exceptions.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/product/product_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isSeeAll = false;
  bool isHoverButton = false;
  bool isLoading = true;

  List<CategoryModel> categories = [];

  final List<CategoryModel> defaultCategories = [
    CategoryModel(
        id: '1',
        name: 'PC',
        image: CategoryImage(publicId: '', url: 'assets/images/pc.png'),
        isActive: true),
    CategoryModel(
        id: '2',
        name: 'Monitor',
        image: CategoryImage(publicId: '', url: 'assets/images/monitor.png'),
        isActive: true),
    CategoryModel(
        id: '3',
        name: 'Laptop',
        image: CategoryImage(publicId: '', url: 'assets/images/laptop.png'),
        isActive: true),
    CategoryModel(
        id: '4',
        name: 'Best Seller',
        image:
            CategoryImage(publicId: '', url: 'assets/images/best_seller.png'),
        isActive: true),
    CategoryModel(
        id: '5',
        name: 'Keyboard',
        image: CategoryImage(publicId: '', url: 'assets/images/keyboard.png'),
        isActive: true),
    CategoryModel(
        id: '6',
        name: 'Mouse',
        image: CategoryImage(publicId: '', url: 'assets/images/mouse.png'),
        isActive: true),
    CategoryModel(
        id: '7',
        name: 'Desktop',
        image: CategoryImage(publicId: '', url: 'assets/images/desktop.png'),
        isActive: true),
    CategoryModel(
        id: '8',
        name: 'Headphone',
        image: CategoryImage(publicId: '', url: 'assets/images/headphone.png'),
        isActive: true),
  ];

  final Map<String, String> categoriesIcon = {
    'PC': 'assets/icons/Category00003.svg',
    'Monitor': 'assets/icons/Category00004.svg',
    'Laptop': 'assets/icons/Category00002.svg',
    'Best Seller': 'assets/icons/laptop.svg',
    'Keyboard': 'assets/icons/Category00006.svg',
    'Mouse': 'assets/icons/Category00007.svg',
    'Desktop': 'assets/icons/Category00003.svg',
    'Headphone': 'assets/icons/Category00005.svg',
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

  Future<void> fetchCategories() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      await productProvider.fetchCategories();

      setState(() {
        if (productProvider.categories.isNotEmpty) {
          categories = productProvider.categories;
        } else {
          categories = defaultCategories;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        categories = defaultCategories;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxVisible = Responsive.isDesktop(context)
        ? categories.length
        : (Responsive.isTablet(context) ? 6 : 4);
    final itemCount = isSeeAll
        ? categories.length
        : (categories.length > maxVisible ? maxVisible : categories.length);

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
                fontSize: lerpDouble(
                    16, 18, (MediaQuery.of(context).size.width - 300) / 300),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!Responsive.isDesktop(context))
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
              )
          ],
        ),
        // Danh mục sản phẩm
        isLoading
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context)
                      ? categoriesIcon.length
                      : Responsive.isTablet(context)
                          ? 6
                          : 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoriesIcon.length,
                itemBuilder: (context, index) => SkeletonCategoryItem(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context)
                      ? categoriesIcon.length
                      : Responsive.isTablet(context)
                          ? 6
                          : 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (context, index) => ListCategoryWidget(
                  isHoverButton: isHoverButton,
                  icon: categoriesIcon[categories[index].name] ??
                      'assets/icons/Category00008.svg',
                  text: categories[index].name,
                ),
              ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Text(
                'Popular',
                style: TextStyle(
                    fontSize: lerpDouble(16, 18,
                        (MediaQuery.of(context).size.width - 300) / 300),
                    fontWeight: FontWeight.bold),
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
  Future<void> _fetchProducts() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    productProvider.clearFilters();

    try {
      await productProvider.fetchProducts(page: 1, limit: 12);
    } on BadRequestException catch (e) {
      // Xử lý lỗi, ví dụ hiện snackbar hoặc log
      print('Error fetching products: ${e.message}');
      // Có thể show alert, hoặc đặt state lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ProductPageView(
        //       categoryId: widget.text,
        //     ),
        //   ),
        // )
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductPageView(categoryId: widget.text)),
        ).then((_) {
          _fetchProducts();
        })
      },
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isHoverButton
                  ? AppColors.orangePastel
                  : AppColors.white,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    return GestureDetector(
      onTap: () {},
      child: Stack(
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
      ),
    );
  }
}
