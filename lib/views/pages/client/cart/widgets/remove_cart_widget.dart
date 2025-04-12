import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/models/item_cart.dart';
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
  int quantityToRemove;
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
        padding:
            const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Remove from cart?',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(height: 10),
            const Divider(
              indent: 0,
              endIndent: 0,
              thickness: 1,
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
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
                  child: ElevatedButton(
                    onPressed: widget.removeItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Yes, Remove',
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
