import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/views/pages/client/cart/cart_view.dart';
import 'package:computer_sales_app/views/pages/client/cart/web/widget/WebCartItemWidget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/empty_cart_widget.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/promocode_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';


class WebCartView extends StatefulWidget {
  const WebCartView({super.key});

  @override
  State<WebCartView> createState() => _WebCartViewState();
}

class _WebCartViewState extends State<WebCartView> {
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
        backgroundColor: AppColors.primary,
      ),
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          SizedBox(width: 150),
          Expanded(
            flex: 2,
            child: Container(
              // Container for Cart
              margin: EdgeInsets.only(top: 50, bottom: 50),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey, width: 0.5),
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
                          color: AppColors.secondary,
                          weight: 700,
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(AppColors.secondary),
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
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      SizedBox(width: 50),
                      Expanded(
                          child: Text(
                        "Quantity",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      SizedBox(width: 50),
                      Expanded(
                        child: Text("Price",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: cartItems.isEmpty
                        ? EmptyCartView()
                        : ListView.builder(
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
          SizedBox(width: 100),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: PromocodeSectionWidget(cartItems: cartItems),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 150),
        ],
      ),
    );
  }
}
