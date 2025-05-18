import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdvancedChart extends StatelessWidget {
  final String timeFrame;
  final List<Map<String, dynamic>> data;
  final DateTime? startDate;
  final DateTime? endDate;

  const AdvancedChart({
    super.key,
    required this.timeFrame,
    required this.data,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Comparison ($timeFrame)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMaxY(),
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final period = data[groupIndex]['period'];
                      final metric = ['Orders', 'Revenue', 'Profit', 'Products', 'Categories'][rodIndex];
                      final value = rod.toY.toInt();
                      return BarTooltipItem(
                        '$period\n$metric: $value',
                        const TextStyle(color: Colors.black, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= data.length) return const Text('');
                        return Text(data[value.toInt()]['period'], style: const TextStyle(fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (index) {
                  final item = data[index];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(toY: item['orders'].toDouble(), color: Colors.blue, width: 10),
                      BarChartRodData(toY: item['revenue'].toDouble() / 10000, color: Colors.green, width: 10),
                      BarChartRodData(toY: item['profit'].toDouble() / 10000, color: Colors.purple, width: 10),
                      BarChartRodData(toY: item['products'].toDouble(), color: Colors.orange, width: 10),
                      BarChartRodData(toY: item['categories'].toDouble(), color: Colors.red, width: 10),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  double _calculateMaxY() {
    double maxY = 0;
    for (var item in data) {
      maxY = [
        maxY,
        item['orders'].toDouble(),
        item['revenue'].toDouble() / 10000,
        item['profit'].toDouble() / 10000,
        item['products'].toDouble(),
        item['categories'].toDouble(),
      ].reduce((a, b) => a > b ? a : b);
    }
    return maxY * 1.1; // Add 10% padding
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      children: [
        _buildLegendItem('Orders', Colors.blue),
        _buildLegendItem('Revenue (x10k)', Colors.green),
        _buildLegendItem('Profit (x10k)', Colors.purple),
        _buildLegendItem('Products', Colors.orange),
        _buildLegendItem('Categories', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}