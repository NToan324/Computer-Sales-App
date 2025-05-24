import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:flutter/material.dart';

class PromocodeSectionWidget extends StatefulWidget {
  const PromocodeSectionWidget({super.key, required this.cartItems});
  final List<ProductForCartModel> cartItems;

  @override
  State<PromocodeSectionWidget> createState() => _PromocodeSectionWidgetState();
}

class _PromocodeSectionWidgetState extends State<PromocodeSectionWidget> {
  String _selectedShippingMethod = 'Express delivery';
  double voucherDiscountMoney = 0;

  final List<String> _shippingMethods = [
    'Pickup at store',
    'Express delivery',
  ];

  double get subtotal {
    double total = widget.cartItems.fold(
      0,
      (sum, item) =>
          sum +
          (item.unitPrice - item.unitPrice * item.discount) * item.quantity,
    );
    // Trừ thêm voucherDiscountMoney cho toàn bộ đơn hàng
    total -= voucherDiscountMoney;
    if (total < 0) total = 0;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, 'voucher');
                if (result != null) {
                  setState(() {
                    voucherDiscountMoney = result as double;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [
                  Text(
                    'Voucher',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 255, 222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          formatMoney(voucherDiscountMoney),
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 0, 69, 23),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping method',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                DropdownButton<String>(
                  elevation: 1,
                  dropdownColor: Colors.white,
                  value: _selectedShippingMethod,
                  items: _shippingMethods.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedShippingMethod = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.black12,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Subtotal Pay',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        formatMoney(subtotal),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'payment', arguments: {
                          'shippingMethod': _selectedShippingMethod,
                          'voucherDiscountMoney': voucherDiscountMoney,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
