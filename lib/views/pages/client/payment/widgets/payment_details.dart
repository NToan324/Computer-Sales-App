import 'package:computer_sales_app/components/custom/my_text_field.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatelessWidget {
  final double totalAmount;

  PaymentDetails({super.key, required this.totalAmount});
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _addressControler = TextEditingController();
  final FocusNode _addressFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black.withAlpha(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // Customer Name
          const Text('Customer Name'),
          const SizedBox(height: 4),
          MyTextField(
            hintText: 'Full name',
            prefixIcon: Icons.person_outline_rounded,
            controller: _emailController,
            focusNode: _emailFocus,
            obscureText: false,
          ),
          const SizedBox(height: 16),
          // Shipping Address
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

          // Payment Method
          const Text('Payment Method'),
          const SizedBox(height: 4),
          Container(
            color: Colors.white,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              items: const [
                DropdownMenuItem(
                  value: 'cash',
                  child: Text('Cash', style: TextStyle(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'bank_transfer',
                  child: Text('Bank Transfer', style: TextStyle(fontSize: 14)),
                )
              ],
              onChanged: (value) {},
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
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withAlpha(30),
              ),
              child: Column(
                children: [
                  _buildRowWithLabel(
                      label: 'Subtotal', value: formatMoney(totalAmount)),
                  _buildRowWithLabel(label: 'Shipping', value: 'FREE'),
                  _buildRowWithLabel(
                      label: 'Total', value: formatMoney(totalAmount)),
                ],
              )),

          const SizedBox(height: 16),
          if (!Responsive.isMobile(context))
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'payment');
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
