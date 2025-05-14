import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/review/widgets/item_reviewed_widget.dart';
import 'package:computer_sales_app/views/pages/client/review/widgets/text_field_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/utils/responsive.dart';

void main(List<String> args) {
  runApp(ReviewView(product: product));
}

var product = ProductModel(
  id: "1",
  productId: "prod_123",
  variantName: "Macbook Pro 2021",
  variantColor: "Silver",
  variantDescription: "RAM: 16GB, Storage: 512GB SSD",
  price: 13000000,
  discount: 0.1, // Example discount of 10%
  quantity: 100,
  averageRating: 4.5,
  reviewCount: 150,
  images: [
    ProductImage(url: "assets/images/laptop.png", publicId: "public_id_123")
  ],
  isActive: true,
);

class ReviewView extends StatelessWidget {
  final ProductModel product;
  const ReviewView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: CustomAppBarMobile(title: "Leave Review"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ItemReviewedWidget(product: product),
            ),
            Divider(
              height: 50,
              indent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
              endIndent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
            ),
            Text("How is your order?",
                style: TextStyle(
                    fontSize: FontSizes.large,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold)),
            Divider(
              height: 50,
              indent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
              endIndent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
            ),
            Text("Your overall rating",
                style: TextStyle(
                  fontSize: FontSizes.medium,
                  color: AppColors.grey,
                )),
            SizedBox(height: 10),
            RatingBar.builder(
              glow: false,
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
            Divider(
              height: 50,
              indent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
              endIndent: Responsive.isMobile(context)
                  ? 30
                  : MediaQuery.sizeOf(context).width * 0.15,
            ),
            Text(
              "Write detailed review",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: FontSizes.medium,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold),
            ),
            TextFieldReviewWidget(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: Responsive.isMobile(context)
                      ? MediaQuery.sizeOf(context).width * 0.05
                      : MediaQuery.sizeOf(context).width * 0.15,
                ),
                SizedBox(
                  width: Responsive.isMobile(context)
                      ? MediaQuery.sizeOf(context).width * 0.4
                      : MediaQuery.sizeOf(context).width * 0.1,
                  child: Expanded(
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt, color: AppColors.white),
                        label: Expanded(
                          child: Text(
                            "Upload Photo",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        title: "Cancel",
                        onPressed: () {},
                        backgroundColor: AppColors.lightGrey,
                        textColor: AppColors.black),
                    CustomButton(
                        title: "Submit",
                        onPressed: () {},
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white)
                  ]),
            )
          ],
        ),
      ),
    ));
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: Expanded(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
