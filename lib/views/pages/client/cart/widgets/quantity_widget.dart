import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
    this.maxQuantity,
    required this.productId,
    this.onChangeProgressing,
    this.isProcessing = false,
  });

  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;
  final String productId;
  final bool isProcessing;
  final Function(bool)? onChangeProgressing;

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != oldWidget.initialQuantity) {
      setState(() {
        _quantity = widget.initialQuantity;
      });
    }
  }

  void _incrementQuantity() async {
    if (widget.isProcessing) return;
    if (widget.onChangeProgressing != null) widget.onChangeProgressing!(true);

    try {
      final provider = Provider.of<CartProvider>(context, listen: false);

      if (widget.maxQuantity == null || _quantity < widget.maxQuantity!) {
        await provider.handleAddToCart(widget.productId, 1);

        setState(() {
          _quantity++;
        });

        widget.onQuantityChanged(_quantity);
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (widget.onChangeProgressing != null) {
          widget.onChangeProgressing!(false);
        }
      });
    }
  }

  void _decrementQuantity() async {
    if (widget.isProcessing) return;
    if (widget.onChangeProgressing != null) widget.onChangeProgressing!(true);

    try {
      final provider = Provider.of<CartProvider>(context, listen: false);

      if (_quantity > 1) {
        await provider.handleRemoveToCart(widget.productId, 1);

        setState(() {
          _quantity--;
        });

        widget.onQuantityChanged(_quantity);
      } else {
        showCustomSnackBar(context, "You can't descrease quantity below 1");
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (widget.onChangeProgressing != null) {
          widget.onChangeProgressing!(false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            width: 25,
            height: 25,
            child: IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: _decrementQuantity,
              padding: EdgeInsets.zero,
              color: AppColors.black,
              constraints: const BoxConstraints(),
            ),
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              color: AppColors.black,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            width: 25,
            height: 25,
            child: IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: _incrementQuantity,
              color: AppColors.white,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
