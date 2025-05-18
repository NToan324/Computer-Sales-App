import 'package:computer_sales_app/components/custom/bottom_navigation_bar.dart';
import 'package:computer_sales_app/components/custom/pagination.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/components/ui/slider_product.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:computer_sales_app/models/review.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/services/product.service.dart';
import 'package:computer_sales_app/services/review.service.dart';
import 'package:computer_sales_app/services/socket_io_client.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/description_product.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/product_comment.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/product_review_section.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/quantity.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/title_product.dart';
import 'package:computer_sales_app/views/pages/client/product/widgets/version_product.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView(
      {super.key, required this.productId, required this.categoryId});
  final String productId;
  final String categoryId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late ProductModel product;
  List<ProductModel> relatedProductsVariant = [];

  List<ReviewModel> reviews = [];
  List<ReviewModel> comments = [];
  int currentPage = 0;
  int totalPages = 0;
  bool isLoadingReview = false;
  bool isLoadingComment = false;

  double averageRating = 0.0;
  int reviewCount = 0;

  List<String> images = ['https://placehold.co/600x400.png'];
  int quantity = 1;
  bool isLoading = false;

  final SocketService socketService = SocketService();
  ProductService productService = ProductService();
  ReviewService reviewService = ReviewService();

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
        images = newProduct.images.map((image) => image.url).toList();
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleSelectVariant(String variantId) async {
    final newProduct =
        relatedProductsVariant.firstWhere((variant) => variant.id == variantId);

    setState(() {
      product = newProduct;
      images = newProduct.images.map((image) => image.url).toList();
    });

    // Ngắt kết nối socket hiện tại (nếu cần), rồi kết nối lại
    socketService.disconnect();
    await socketService.connect(productVariantId: newProduct.id);

    // Đăng ký lại lắng nghe review mới
    socketService.onNewReview((data) {
      final newReview = ReviewModel.fromJson(data);
      if (newReview.rating != 0) {
        setState(() {
          reviews.insert(0, newReview);
          reviewCount += 1;

          if (reviewCount == 1) {
            averageRating = newReview.rating!.toDouble();
          } else {
            averageRating =
                ((averageRating * (reviewCount - 1)) + newReview.rating!) /
                    reviewCount;
          }
        });
      } else {
        setState(() {
          comments.insert(0, newReview);
        });
      }
    });

    await fetchReviewsRating();
    await fetchComments();
  }

  Future<void> fetchReviewsRating({int page = 1}) async {
    setState(() {
      isLoadingReview = true;
      reviews.clear();
    });
    try {
      final res = await reviewService.getAllReviews(
        productVariantId: product.id,
        page: page,
        limit: 200,
      );
      //Only get reviews with rating
      final filterReviewsRating = res['data']
          .where((review) => review.userId != null && review.rating != 0)
          .toList();
      if (res['data'].isNotEmpty) {
        setState(() {
          reviews.addAll(
            filterReviewsRating,
          );
          totalPages = res['totalPage'];
          currentPage = res['page'];
          averageRating = (res['average_rating'] ?? 0).toDouble();
          reviewCount = res['reviews_with_rating'];
        });
      } else {
        setState(() {
          averageRating = 0;
          reviewCount = 0;
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }

    setState(() {
      isLoadingReview = false;
    });
  }

  Future<void> fetchComments({int page = 1}) async {
    setState(() {
      isLoadingComment = true;
      comments.clear();
    });
    try {
      final res = await reviewService.getAllReviews(
        productVariantId: product.id,
        page: page,
        limit: 200,
      );
      //only get comments without rating
      final filterReview =
          res['data'].where((review) => review.rating == 0).toList();

      if (res['data'].isNotEmpty) {
        setState(() {
          comments.addAll(
            filterReview,
          );
          totalPages = res['totalPage'];
          currentPage = res['page'];
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }

    setState(() {
      isLoadingComment = false;
    });
  }

  Future<void> _initSocketAndLoadData() async {
    await socketService.connect(productVariantId: product.id);
    socketService.onNewReview((data) async {
      final newReview = ReviewModel.fromJson(data);
      // Chỉ thêm nếu có rating hợp lệ
      if (newReview.rating != 0) {
        setState(() {
          reviews.insert(0, newReview);
          reviewCount = reviews.length;

          if (reviewCount == 1) {
            averageRating = newReview.rating!.toDouble();
          } else {
            averageRating =
                ((averageRating * (reviewCount - 1)) + newReview.rating!) /
                    reviewCount;
          }
        });
      } else {
        setState(() {
          comments.insert(0, newReview);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    product = ProductModel(
      id: widget.productId,
      productId: '',
      variantName: '',
      variantColor: '',
      variantDescription: '',
      price: 0,
      discount: 0,
      quantity: 0,
      averageRating: 0,
      reviewCount: 0,
      images: [
        ProductImage(url: 'https://placehold.co/600x400.png', publicId: '')
      ],
      isActive: true,
    );
    fetchProductDetails().then((_) {
      _initSocketAndLoadData(); // Chỉ gọi sau khi đã có product.id chính xác
    });
    fetchReviewsRating();
    fetchComments();
  }

  @override
  void dispose() {
    super.dispose();
    socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    double isWrap = MediaQuery.of(context).size.width;
    bool isMobile = Responsive.isMobile(context);
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);

    //get data from route arguments
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
                          averageRating: averageRating,
                          reviewCount: reviewCount,
                          images: images,
                          socketService: socketService,
                          reviews: reviews,
                          isLoading: isLoadingReview,
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
                          ),
                    child: ProductRelevant(
                      categoryId: widget.categoryId,
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
                          ),
                    child: ProductComment(
                      socketService: socketService,
                      productId: product.id,
                      comments: comments,
                      isLoading: isLoadingComment,
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      icon: CupertinoIcons.square_grid_2x2,
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

class ProductRelevant extends StatefulWidget {
  const ProductRelevant({
    super.key,
    required this.categoryId,
  });

  final String categoryId;
  @override
  State<ProductRelevant> createState() => _ProductRelevantState();
}

class _ProductRelevantState extends State<ProductRelevant> {
  bool _isLoading = true;
  List<ProductModel> products = [];
  int totalPage = 0;
  int currentPage = 1;
  String errorMessage = '';
  final ProductService productSerice = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchProductsRelevant();
  }

  Future<void> _fetchProductsRelevant() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final getProductVariants = await productSerice
          .searchProductVariants(categoryIds: [widget.categoryId]);

      setState(() {
        products = getProductVariants['data'];
        totalPage = getProductVariants['totalPages'];
        currentPage = getProductVariants['page'];
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleOnPageChanged(int page) async {
    setState(() {
      currentPage = page;
    });
    await _fetchProductsRelevant();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          itemCount: _isLoading ? 10 : products.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 350,
          ),
          itemBuilder: (context, index) {
            final variant =
                !_isLoading && index < products.length ? products[index] : null;
            return _isLoading
                ? Skeleton()
                : ProductView(
                    id: variant?.id ?? '',
                    categoryId: variant?.categoryId ?? '',
                    variantName: variant?.variantName ?? '',
                    images: (variant?.images as List<ProductImage>),
                    price: (variant?.price as double),
                    variantDescription: variant?.variantDescription ??
                        'No description available',
                    averageRating: variant?.averageRating.toString() ?? '0.0',
                  );
          },
        ),
        SizedBox(
          height: 20,
        ),
        PaginationWidget(
          currentPage: currentPage,
          totalPages: totalPage,
          onPageChanged: (page) {
            handleOnPageChanged(page);
          },
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ProductView extends StatelessWidget {
  final String variantName;
  final List<ProductImage> images;
  final double price;
  final String variantDescription;
  final String averageRating;
  final String id;
  final String categoryId;

  const ProductView({
    super.key,
    required this.id,
    required this.variantName,
    required this.images,
    required this.price,
    required this.variantDescription,
    required this.averageRating,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/product-details/$id', arguments: {
        'categoryId': categoryId,
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 219, 219, 219)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 150, maxHeight: 350),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                height: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: images[0].url.isNotEmpty
                      ? Image.network(
                          images[0].url,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/laptop.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    variantName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    variantDescription,
                    style: TextStyle(
                      fontSize: FontSizes.small,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    formatMoney(price.toDouble()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      fontSize: FontSizes.medium,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 15, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(double.parse(averageRating).toStringAsFixed(1)),
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
