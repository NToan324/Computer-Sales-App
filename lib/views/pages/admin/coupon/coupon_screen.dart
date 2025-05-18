import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:computer_sales_app/provider/coupon_provider.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/widgets/add_coupon_btn.dart';
import 'package:computer_sales_app/views/pages/admin/coupon/widgets/coupon_table.dart';

class CouponManagementScreen extends StatelessWidget {
  const CouponManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CouponProvider()..loadCoupons(),
      child: Consumer<CouponProvider>(
        builder: (context, provider, child) {
          return Container(
            color: Colors.grey[100],
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AddCouponButton(),
                  const SizedBox(height: 16),
                  if (provider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (provider.errorMessage != null)
                    Center(child: Text(provider.errorMessage!))
                  else if (provider.coupons == null || provider.coupons!.isEmpty)
                      const Center(child: Text('No coupons found'))
                    else
                      CouponTable(
                        coupons: provider.coupons!.map((coupon) => coupon.toMap()).toList(),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}