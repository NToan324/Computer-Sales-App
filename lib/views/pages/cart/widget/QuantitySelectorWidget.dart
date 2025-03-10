import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class QuantitySelectorWidget extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final int? maxQuantity;

  const QuantitySelectorWidget({
    super.key,
    required this.initialQuantity,
    required this.onQuantityChanged,
    this.maxQuantity,
  });

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelectorWidget> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  void didUpdateWidget(covariant QuantitySelectorWidget oldWidget) {
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
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: BackgroundColor.grayBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.remove, size: 16),
              onPressed: _decrementQuantity,
              padding: EdgeInsets.zero,
              color: AppColor.black,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$_quantity',
            style: const TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: AppColor.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.add, size: 16),
              onPressed: _incrementQuantity,
              color: AppColor.white,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }
}
