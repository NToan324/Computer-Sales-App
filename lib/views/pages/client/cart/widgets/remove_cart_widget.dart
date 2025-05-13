import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

class RemoveCartWidget extends StatefulWidget {
   RemoveCartWidget(
      {super.key,
      required this.cartItems,
      required this.itemToRemove,
      required this.cancelRemoveItem,
      required this.quantityToRemove,
      required this.removeItem});

  final List<CartItem> cartItems;
  final int? itemToRemove;
  final VoidCallback cancelRemoveItem;
  late int quantityToRemove;
  final VoidCallback removeItem;

  @override
  State<RemoveCartWidget> createState() => _RemoveCartWidgetState();
}

class _RemoveCartWidgetState extends State<RemoveCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            CartItemWidget(
              item: widget.cartItems[widget.itemToRemove!],
              onQuantityChanged: (newQuantity) {
                setState(() {
                  widget.quantityToRemove = newQuantity;
                });
              },
              maxQuantity: widget.cartItems[widget.itemToRemove!].quantity,
              isRemove: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: widget.cancelRemoveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 200, 200, 200)
                          .withAlpha(200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: widget.removeItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
