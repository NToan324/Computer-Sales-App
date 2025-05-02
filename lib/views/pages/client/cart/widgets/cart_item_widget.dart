import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {
  final bool isRemove;
  final CartItem item;
  final ValueChanged<int>? onQuantityChanged;
  final int? maxQuantity;

  const CartItemWidget({
    super.key,
    required this.item,
    this.onQuantityChanged,
    this.isRemove = false,
    this.maxQuantity,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  // bool _isCheck = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PRODUCT
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: Image.asset(widget.item.image).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formatMoney(widget.item.price),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // QUANTITY
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: Responsive.isMobile(context)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  QuantitySelector(
                    initialQuantity: widget.item.quantity,
                    onQuantityChanged: widget.onQuantityChanged ?? (val) {},
                    maxQuantity: widget.maxQuantity,
                  ),
                ],
              ),
            ),

            // TOTAL
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 1,
                child: Text(
                  formatMoney(widget.item.price * widget.item.quantity),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            // REMOVE
            if (!Responsive.isMobile(context))
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              )
          ],
        ),
      ),
    );
  }
}
