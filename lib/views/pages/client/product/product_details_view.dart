import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/components/ui/slider_product.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/product_widget.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/description_product.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/product_comment.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/product_preview_section.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/quantity.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/title_product.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/version_product.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  ProductModel product = ProductModel(
    id: '',
    productId: '',
    variantName: '',
    variantColor: '',
    variantDescription: '',
    price: 0,
    discount: 0,
    quantity: 0,
    averageRating: 0,
    reviewCount: 0,
    images: [],
    isActive: true,
  );
  List<ProductModel> relatedProductsVariant = [];
  List<String> images = [];
  int quantity = 1;
  bool isLoading = false;

  ProductService productService = ProductService();
  Future<void> fetchProductDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await productService.getProductVariantsById(widget.productId);

      final newProduct = ProductModel.fromJson(response['productVariant']);
      final newRelated = (response['relatedVariants'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();

      setState(() {
        product = newProduct;
        relatedProductsVariant = [newProduct, ...newRelated];
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleSelectVariant(String variantId) {
    setState(() {
      product = relatedProductsVariant
          .firstWhere((variant) => variant.id == variantId);
      images = product.images.map((image) => image.url).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    double isWrap = MediaQuery.of(context).size.width;
    bool isMobile = Responsive.isMobile(context);
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);

    if (product.images.isNotEmpty) {
      images = product.images.map((image) => image.url).toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !isMobile ? AppBarHomeCustom() : null,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 40,
                runSpacing: 20,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300,
                      minHeight: 300,
                    ),
                    child: Container(
                        padding: !isMobile
                            ? EdgeInsets.only(
                                top: 16,
                                left: 64,
                                right: 64,
                              )
                            : EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                        height: isMobile ? 300 : 500,
                        width: isWrap < 1200 ? double.infinity : isWrap * 0.52,
                        child: SliderProductCustom(
                          imagesUrl: images,
                          isLoading: isLoading,
                        )),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300,
                    ),
                    child: Container(
                      padding: !isMobile
                          ? EdgeInsets.only(
                              top: 16,
                              left: 64,
                              right: 64,
                            )
                          : EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                      width: isWrap < 1200 ? double.infinity : isWrap * 0.43,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          TitleProduct(
                            title: product.variantName,
                            price: product.price,
                            discount: product.discount,
                          ),
                          VersionProduct(
                            relatedProductsVariant: relatedProductsVariant,
                            handleSelectVariant: handleSelectVariant,
                            isSelected: product.id,
                          ),
                          Quantity(
                            quantity: quantity,
                            onIncrease: () {
                              if (quantity < 99) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                            onDecrease: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          if (!isMobile)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 200,
                                    minWidth: 150,
                                    minHeight: 50,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final provider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      provider.handleAddToCart(
                                        product.id,
                                        quantity,
                                      );
                                      showCustomSnackBar(
                                        context,
                                        'You have added to cart',
                                        type: SnackBarType.success,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Add to cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 200,
                                    minWidth: 150,
                                    minHeight: 50,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: AppColors.primary,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Buy now',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: !isDesktop ? double.infinity : isWrap * 0.43,
                    padding: !isMobile
                        ? EdgeInsets.only(
                            top: 16,
                            left: 64,
                            right: 64,
                          )
                        : EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        DescriptionProduct(
                          description: product.variantDescription,
                        ),
                        ProductReviewSection(
                          productId: product.id,
                          productName: product.variantName,
                          averageRating: product.averageRating ?? 0,
                          reviewCount: product.reviewCount ?? 0,
                          images: images,
                        ),
                        Text(
                          'Related Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: !isMobile
                        ? EdgeInsets.only(
                            top: 16,
                            left: 64,
                            right: 64,
                          )
                        : EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                    child: ProductListViewWidget(),
                  ),
                  Padding(
                    padding: !isMobile
                        ? EdgeInsets.only(
                            top: 16,
                            left: 64,
                            right: 64,
                          )
                        : EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                    child: ProductComment(),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            if (isTablet)
              Positioned(
                top: 0,
                left: 64,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationBarCustom(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (isMobile)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonCustom(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButtonCustom(
                      icon: Icons.share_rounded,
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            // isMobile ? DraggableScrollCustom() : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(70),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              width: double.infinity,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Icon(
                          FeatherIcons.messageCircle,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                    height: 50,
                    child: Container(
                      color: Colors.black.withAlpha(100),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'cart');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Icon(
                            FeatherIcons.shoppingCart,
                            color: Colors.black,
                            size: 25,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final provider =
                              Provider.of<CartProvider>(context, listen: false);
                          provider.handleAddToCart(
                            product.id,
                            quantity,
                          );
                          showCustomSnackBar(
                            context,
                            'You have added to cart',
                            type: SnackBarType.success,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          'Add to cart',
                          style: TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : null,
    );
  }
}

class IconButtonCustom extends StatelessWidget {
  const IconButtonCustom({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          onPressed();
        },
        icon: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}
