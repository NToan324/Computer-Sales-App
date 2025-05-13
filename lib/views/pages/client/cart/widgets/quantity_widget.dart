import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
    this.maxQuantity,
  });

  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;

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

  void _incrementQuantity() {
    if (widget.maxQuantity == null || _quantity < widget.maxQuantity!) {
      setState(() {
        _quantity++;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
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
