import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/info_card.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/daily_progress.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/customer_table.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/revenue_chart.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

 
  @override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần trên: Biểu đồ và thẻ
          Responsive.isDesktop(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: RevenueChart()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildInfoCards(context),
                              const SizedBox(height: 20),
                              DailyProgress(
                                progress: 0.48,
                                currentValue: "39,169,000",
                                maxValue: "100,000,000",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    RevenueChart(),
                    const SizedBox(height: 16),
                    _buildInfoCards(context),
                    const SizedBox(height: 20),
                    DailyProgress(
                      progress: 0.48,
                      currentValue: "39,169,000",
                      maxValue: "100,000,000",
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          // Bảng khách hàng
          SizedBox(
            height: 300,
            child: CustomerTable(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoCards(BuildContext context) {
  int crossAxisCount = 2;
  double childAspectRatio = 2.0;

  if (MediaQuery.of(context).size.width > 1300) {
    crossAxisCount = 2;
    childAspectRatio = 3.0;
  }
  else if (Responsive.isTablet(context)) {
    crossAxisCount = 2;
    childAspectRatio = 3.0;
  } 
  else {
    // Tablet hoặc mobile vừa
    crossAxisCount = 2;
    childAspectRatio = 2.0;
  }

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
    ),
    itemCount: 4,
    itemBuilder: (context, index) {
      final cards = [
        InfoCard(title: "TODAY'S MONEY", value: "990000", color: Colors.green),
        InfoCard(title: "TODAY'S USER", value: "10", color: Colors.blue),
        InfoCard(title: "TODAY'S PRODUCT", value: "489", color: Colors.purple),
        InfoCard(title: "TODAY'S INVOICE", value: "289", color: Colors.orange),
      ];
      return cards[index];
    },
  );
}

}