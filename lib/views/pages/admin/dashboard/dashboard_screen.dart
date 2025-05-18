import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/info_card.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/daily_progress.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/revenue_chart.dart';
import 'package:computer_sales_app/views/pages/admin/dashboard/widgets/advanced_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedTimeFrame = 'Yearly';
  DateTime? _startDate;
  DateTime? _endDate;

  // Mock data for demonstration
  final Map<String, List<Map<String, dynamic>>> _data = {
    'Yearly': [
      {'period': '2023', 'orders': 1200, 'revenue': 1500000, 'profit': 450000, 'products': 800, 'categories': 10},
      {'period': '2024', 'orders': 1500, 'revenue': 2000000, 'profit': 600000, 'products': 1000, 'categories': 12},
      {'period': '2025', 'orders': 1800, 'revenue': 2500000, 'profit': 750000, 'products': 1200, 'categories': 15},
    ],
    'Quarterly': [
      {'period': 'Q1 2025', 'orders': 450, 'revenue': 625000, 'profit': 187500, 'products': 300, 'categories': 8},
      {'period': 'Q2 2025', 'orders': 500, 'revenue': 700000, 'profit': 210000, 'products': 350, 'categories': 9},
    ],
    'Monthly': [
      {'period': 'Jan 2025', 'orders': 150, 'revenue': 200000, 'profit': 60000, 'products': 100, 'categories': 5},
      {'period': 'Feb 2025', 'orders': 160, 'revenue': 220000, 'profit': 66000, 'products': 110, 'categories': 6},
    ],
    'Weekly': [
      {'period': 'Week 1 2025', 'orders': 40, 'revenue': 50000, 'profit': 15000, 'products': 25, 'categories': 3},
      {'period': 'Week 2 2025', 'orders': 45, 'revenue': 55000, 'profit': 16500, 'products': 30, 'categories': 4},
    ],
  };

  void _onTimeFrameChanged(String? value) {
    setState(() {
      _selectedTimeFrame = value!;
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _selectedTimeFrame = 'Custom';
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple Dashboard: Info Cards and Daily Progress
            Text(
              'Store Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoCards(context),
            const SizedBox(height: 20),
            DailyProgress(
              progress: 0.48,
              currentValue: "39,169,000",
              maxValue: "100,000,000",
            ),
            const SizedBox(height: 20),
            // Revenue Chart (Simple Dashboard)
            RevenueChart(),
            const SizedBox(height: 20),
            // Advanced Dashboard: Time Filter and Comparison Charts
            Text(
              'Advanced Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimeFilter(context),
            const SizedBox(height: 20),
            AdvancedChart(
              timeFrame: _selectedTimeFrame,
              data: _data[_selectedTimeFrame] ?? [],
              startDate: _startDate,
              endDate: _endDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    int crossAxisCount = Responsive.isDesktop(context) ? 4 : 2;
    double childAspectRatio = Responsive.isDesktop(context) ? 3.0 : 2.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        final cards = [
          InfoCard(title: "TOTAL USERS", value: "1,234", color: Colors.blue),
          InfoCard(title: "NEW USERS", value: "56", color: Colors.green),
          InfoCard(title: "ORDERS", value: "789", color: Colors.orange),
          InfoCard(title: "REVENUE", value: "39,169,000", color: Colors.purple),
          InfoCard(title: "TOP PRODUCT", value: "Laptop XYZ", color: Colors.red),
        ];
        return cards[index];
      },
    );
  }

  Widget _buildTimeFilter(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedTimeFrame,
          items: ['Yearly', 'Quarterly', 'Monthly', 'Weekly', 'Custom']
              .map((frame) => DropdownMenuItem(value: frame, child: Text(frame)))
              .toList(),
          onChanged: _onTimeFrameChanged,
        ),
        const SizedBox(width: 16),
        if (_selectedTimeFrame == 'Custom')
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: Text(
              _startDate != null && _endDate != null
                  ? '${DateFormat('dd/MM/yy').format(_startDate!)} - ${DateFormat('dd/MM/yy').format(_endDate!)}'
                  : 'Select Date Range',
            ),
          ),
      ],
    );
  }
}