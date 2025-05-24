import 'package:cached_network_image/cached_network_image.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/cart/widgets/quantity_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final bool isRemove;
  final ProductForCartModel itemCart;
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
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool isProcessing = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.itemCart.images.url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 350, // hoặc chiều cao bạn muốn
                          placeholder: (context, url) => const SkeletonImage(
                            imageHeight: 80,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/image_default_error.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                widget.itemCart.productVariantName,
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
                              formatMoney(
                                widget.itemCart.unitPrice -
                                    (widget.itemCart.unitPrice *
                                        widget.itemCart.discount),
                              ),
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
                        productId: widget.itemCart.productVariantId,
                        initialQuantity: widget.itemCart.quantity,
                        onQuantityChanged: widget.onQuantityChanged ?? (val) {},
                        maxQuantity: widget.maxQuantity,
                        isProcessing: isProcessing,
                        onChangeProgressing: (value) {
                          setState(() {
                            isProcessing = value;
                          });
                        },
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
                        widget.itemCart.unitPrice * widget.itemCart.quantity,
                      ),
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
                          .handleDeleteToCart(widget.itemCart.productVariantId);
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
        ),

        // Overlay loading
        if (isProcessing)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withAlpha(50),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
