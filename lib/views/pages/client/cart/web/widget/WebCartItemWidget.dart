import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/models/item_cart.dart';

class WebCartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;
  final int? maxQuantity;

  const WebCartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: Card(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.455,
              child: Row(
                spacing: 15,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage(item.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: FontSizes.medium,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: AppColors.black,
                        decoration: TextDecoration.none,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  QuantitySelector(
                    initialQuantity: item.quantity,
                    onQuantityChanged: onQuantityChanged,
                    maxQuantity: maxQuantity,
                  ),
                  Spacer(),
                  Spacer(),
                  Expanded(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 140, minWidth: 140),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.none,
                          child: Text(
                            formatMoney(item.price),
                            style: const TextStyle(
                              fontSize: FontSizes.medium,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: AppColors.black,
                              decoration: TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.secondary,
                      ),
                      onPressed: () {
                        onRemove();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
