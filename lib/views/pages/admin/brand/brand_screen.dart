import 'package:computer_sales_app/provider/brand_provider.dart';
import 'package:computer_sales_app/views/pages/admin/brand/widgets/brand_table.dart';
import 'package:computer_sales_app/views/pages/admin/brand/widgets/add_brand_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandManagementScreen extends StatefulWidget {
  const BrandManagementScreen({super.key});

  @override
  State<BrandManagementScreen> createState() => _BrandManagementScreenState();
}

class _BrandManagementScreenState extends State<BrandManagementScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);
    brandProvider.fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {
        return Container(
          color: Colors.grey[100],
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddBrandButton(),
                const SizedBox(height: 16),
                BrandTable(brands: brandProvider.getFilteredBrands()),
              ],
            ),
          ),
        );
      },
    );
  }
}