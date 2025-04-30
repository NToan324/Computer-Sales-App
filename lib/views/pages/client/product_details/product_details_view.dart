import 'package:computer_sales_app/components/ui/slider_product.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/home/widgets/appBar_widget.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/color_version.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/quantity.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/review.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/title_product.dart';
import 'package:computer_sales_app/views/pages/client/product_details/widgets/version_product.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  List<String> images = [
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-popular-2.jpg',
    'assets/images/laptop-mockup.jpg',
    'assets/images/laptop-mockup.jpg',
  ];

  ProductDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    double isWrap = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: !Responsive.isMobile(context) ? AppBarHomeCustom() : null,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => Stack(
          children: [
            Container(
              width: double.infinity,
              padding: !Responsive.isMobile(context)
                  ? EdgeInsets.only(
                      top: 16,
                      left: 64,
                      right: 64,
                    )
                  : null,
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
                    child: SizedBox(
                      height: Responsive.isMobile(context) ? 300 : 500,
                      width: isWrap < 1200 ? double.infinity : isWrap * 0.43,
                      child: SliderProductCustom(
                        imagesUrl: images,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 300,
                      minHeight: 500,
                    ),
                    child: Container(
                      padding: Responsive.isMobile(context)
                          ? EdgeInsets.all(8)
                          : null,
                      width: isWrap < 1200 ? double.infinity : isWrap * 0.43,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          TitleProduct(),
                          Reviews(),
                          ColorsVersion(),
                          VersionProduct(
                            title: 'Surface Pro 7 | i5 8GB - 128GB',
                            price: 14900000,
                          ),
                          Quantity(),
                          if (!Responsive.isMobile(context))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {},
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
                                SizedBox(
                                  width: 200,
                                  height: 50,
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
                  )
                ],
              ),
            ),
            if (Responsive.isMobile(context))
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
            // Responsive.isMobile(context) ? DraggableScrollCustom() : SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: Responsive.isMobile(context)
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
                          onPressed: () {},
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          'Buy now',
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
