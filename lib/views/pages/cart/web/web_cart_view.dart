import 'package:computer_sales_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/views/pages/cart/widget/SummaryWidget.dart';
import 'package:computer_sales_app/views/pages/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/cart/web/widget/WebCartItemWidget.dart';

class WebCartView extends StatefulWidget {
  const WebCartView({super.key});

  @override
  State<WebCartView> createState() => _WebCartViewState();
}

class _WebCartViewState extends State<WebCartView> {
  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get deliveryFee => 5.0;

  double get total => subtotal + deliveryFee;

  void clearAll() {
    setState(() {
      cartItems.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: AppColor.primary,
      ),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          spacing: 100,
          children: [
            SizedBox(width: 50),
            Expanded(
              flex: 2,
              child: Container(
                // Container for Cart
                margin: EdgeInsets.only(top: 50, bottom: 50),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(16.0),
                            child: Text(
                              "Cart",
                              style: TextStyle(
                                  fontSize: FontSizes.large,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            clearAll();
                          },
                          label: Text("Clear all",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          icon: Icon(
                            Icons.close,
                            color: AppColor.secondary,
                            weight: 700,
                          ),
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all(AppColor.secondary),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                              margin: EdgeInsets.only(left: 16),
                              child: Text("Product",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        Expanded(
                            child: Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: Text("Price",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return WebCartItemWidget(
                              item: item,
                              onQuantityChanged: (quantity) {
                                setState(() {
                                  cartItems[index] = CartItem(
                                    name: item.name,
                                    price: item.price,
                                    image: item.image,
                                    quantity: quantity,
                                  );
                                });
                              },
                              onRemove: () {
                                removeItem(index);
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: SummaryWidget(
                        // Summary Widget
                        subtotal: subtotal,
                        deliveryFee: deliveryFee,
                        total: total,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
