import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/client/payment/widgets/point_summary.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({
    super.key,
    required this.totalAmount,
    required this.name,
    required this.address,
    required this.email,
    required this.onChangeValue,
    required this.shippingMethod,
    this.currentPoint = 0,
    this.handleCreateOrder,
    this.onUpdateTotalPrice,
    this.voucherDiscountMoney = 0,
  });

  final double totalAmount;
  final String name;
  final String address;
  final String email;
  final Function({
    required String name,
    required String email,
    required String address,
    required String paymentMethod,
  }) onChangeValue;

  final double voucherDiscountMoney;

  final String shippingMethod;
  final double currentPoint;
  final Function? handleCreateOrder;
  final Function(double updatedTotalPrice)? onUpdateTotalPrice;

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  final TextEditingController _addressControler = TextEditingController();
  final FocusNode _addressFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  String _selectedPaymentMethod = 'BANK_TRANSFER';

  double? _lastNotifiedTotalPrice;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _addressControler.text = widget.address;
    _nameController.text = widget.name;

    _nameController.addListener(_notify);
    _emailController.addListener(_notify);
    _addressControler.addListener(_notify);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTotalPrice();
    });
  }

  @override
  void didUpdateWidget(covariant PaymentDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.totalAmount != widget.totalAmount ||
        oldWidget.currentPoint != widget.currentPoint ||
        oldWidget.shippingMethod != widget.shippingMethod) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTotalPrice();
      });
    }
  }

  void _notify() {
    widget.onChangeValue(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressControler.text.trim(),
      paymentMethod: _selectedPaymentMethod,
    );
  }

  void _updateTotalPrice() {
    double maxDiscountFromPoints = widget.totalAmount * 0.5;

    double pointsToUse = widget.currentPoint * 1000 <= maxDiscountFromPoints
        ? widget.currentPoint.floorToDouble()
        : (maxDiscountFromPoints / 1000).floorToDouble();

    double vatPrice = (widget.totalAmount * 0.1).floorToDouble();

    double totalPrice = (widget.totalAmount +
                (widget.shippingMethod == "Pickup at store" ? 0 : 49000) +
                vatPrice -
                pointsToUse * 1000)
            .floorToDouble() -
        widget.voucherDiscountMoney;

    if (_lastNotifiedTotalPrice != totalPrice) {
      _lastNotifiedTotalPrice = totalPrice;
      if (widget.onUpdateTotalPrice != null) {
        widget.onUpdateTotalPrice!(totalPrice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán các giá trị hiển thị, không gọi callback ở đây nữa
    double maxDiscountFromPoints = widget.totalAmount * 0.5;

    double pointsToUse = widget.currentPoint * 1000 <= maxDiscountFromPoints
        ? widget.currentPoint.floorToDouble()
        : (maxDiscountFromPoints / 1000).floorToDouble();

    double pointsToReceive = (widget.totalAmount * 0.0001).floorToDouble();

    double vatPrice = (widget.totalAmount * 0.1).floorToDouble();

    double totalPrice = (widget.totalAmount +
            (widget.shippingMethod == "Pickup at store" ? 0 : 49000) +
            vatPrice -
            pointsToUse * 1000 -
            widget.voucherDiscountMoney)
        .floorToDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withAlpha(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... phần UI giữ nguyên, không thay đổi
          const Text(
            'Payment Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: 300,
            child: Text(
              'Complete your purchase by filling in the payment details below',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Phone'),
          const SizedBox(height: 4),
          MyTextField(
            hintText: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            focusNode: _emailFocus,
            obscureText: false,
          ),
          const SizedBox(height: 16),
          const Text('Customer Name'),
          const SizedBox(height: 4),
          MyTextField(
            hintText: 'Full name',
            prefixIcon: Icons.person_outline_rounded,
            controller: _nameController,
            focusNode: _nameFocus,
            obscureText: false,
          ),
          const SizedBox(height: 16),
          const Text('Shipping Address'),
          const SizedBox(height: 4),
          MyTextField(
            hintText: 'Address',
            prefixIcon: Icons.location_on_outlined,
            controller: _addressControler,
            focusNode: _addressFocus,
            obscureText: false,
          ),
          const SizedBox(height: 16),
          const Text('Payment Method'),
          const SizedBox(height: 4),
          Container(
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              items: const [
                DropdownMenuItem(
                  value: 'CASH',
                  child: Text('Cash', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'BANK_TRANSFER',
                  child: Text('Bank Transfer', style: TextStyle(fontSize: 14)),
                )
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
                _notify();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.payment_outlined,
                  color: Colors.grey,
                ),
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                hintText: 'Select payment method',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          PointSummary(
            currentPoints: widget.currentPoint,
            pointsToUse: pointsToUse,
            pointsToReceive: pointsToReceive,
          ),
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withAlpha(20),
              ),
              child: Column(
                children: [
                  _buildRowWithLabel(
                      label: 'Subtotal',
                      value: formatMoney(widget.totalAmount)),
                  _buildRowWithLabel(
                      label: 'Voucher',
                      value: formatMoney(widget.voucherDiscountMoney)),
                  _buildRowWithLabel(
                      label: 'Vat (10%)', value: formatMoney(vatPrice)),
                  _buildRowWithLabel(
                    label: 'Shipping',
                    value: widget.shippingMethod == "Pickup at store"
                        ? "Free"
                        : formatMoney(49000),
                  ),
                  _buildRowWithLabel(
                      label: 'Total', value: formatMoney(totalPrice)),
                ],
              )),
          const SizedBox(height: 16),
          if (!Responsive.isMobile(context))
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  widget.handleCreateOrder?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Order Now',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRowWithLabel({required String label, String? value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          Text(
            value ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
