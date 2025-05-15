import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final bool isRemove;
  final CartModel itemCart;
  final ValueChanged<int>? onQuantityChanged;
  final int? maxQuantity;

  const CartItemWidget({
    super.key,
    required this.itemCart,
    this.onQuantityChanged,
    this.isRemove = false,
    this.maxQuantity,
  });

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
                          image: NetworkImage(
                            (itemCart.items.images.url.isNotEmpty)
                                ? itemCart.items.images.url
                                : 'https://placehold.co/600x400.png', // ảnh mặc định
                          ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            itemCart.items.productVariantName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          formatMoney(itemCart.items.unitPrice +
                              (itemCart.items.unitPrice *
                                  itemCart.items.discount)),
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
                    productId: itemCart.items.productVariantId,
                    initialQuantity: itemCart.items.quantity,
                    onQuantityChanged: onQuantityChanged ?? (val) {},
                    maxQuantity: maxQuantity,
                  ),
                ],
              ),
            ),

            // TOTAL
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 1,
                child: Text(
                  formatMoney(
                      itemCart.items.unitPrice * itemCart.items.quantity),
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
                onPressed: () {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  cartProvider
                      .handleDeleteToCart(itemCart.items.productVariantId);
                  showCustomSnackBar(
                    context,
                    'Delete product from cart successfully',
                    type: SnackBarType.success,
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
