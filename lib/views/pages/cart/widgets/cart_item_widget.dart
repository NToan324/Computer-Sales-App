import 'package:computer_sales_app/components/custom/checkbox_custom.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/item_cart.dart';
import 'package:computer_sales_app/views/pages/cart/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;
  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          // CheckBoxCustom(
          //   value: _isCheck,
          //   onChange: () {
          //     setState(() {
          //       _isCheck = !_isCheck;
          //     });
          //   },
          // ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
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
                  Expanded(
                    flex: 2,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Macbook Pro M1 2022",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            formatMoney(widget.item.price),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  QuantitySelector(
                    initialQuantity: widget.item.quantity,
                    onQuantityChanged: widget.onQuantityChanged,
                    maxQuantity: widget.maxQuantity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
