import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:computer_sales_app/views/pages/admin/invoice/widgets/invoice_table.dart';
import '../../../../provider/order_provider.dart';

class InvoiceManagementScreen extends StatelessWidget {
  const InvoiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderProvider()..loadOrders(page: 1, limit: 100),
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return Container(
            color: Colors.grey[100],
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (orderProvider.orders == null)
                    const Center(child: CircularProgressIndicator())
                  else if (orderProvider.orders!.isEmpty)
                    const Center(child: Text("No paid invoices found"))
                  else
                    InvoiceTable(
                      invoices: orderProvider.orders!
                          .where((order) => order.paymentStatus == 'PAID')
                          .map((order) => {
                        'id': order.id ?? 'N/A',
                        'customerName': order.userName ?? 'Unknown',
                        'orderDate': order.createdAt?.toIso8601String().split('T')[0] ?? 'N/A',
                        'totalAmount': order.totalAmount ?? 0.0,
                        'discountApplied': order.discountAmount ?? 0.0,
                        'products': (order.items ?? [])
                            .map((item) => {
                          'name': item.productVariantName ?? 'Unknown Product',
                          'quantity': item.quantity ?? 0,
                          'unit_price': item.unit_price ?? 0.0,
                        })
                            .toList(),
                      })
                          .toList(),
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