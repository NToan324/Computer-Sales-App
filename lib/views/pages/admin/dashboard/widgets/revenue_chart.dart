// lib/views/pages/admin/dashboard/widgets/revenue_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Overview",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "-99% from 2019",
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Chú thích (Legend)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Product A", Colors.teal),
              const SizedBox(width: 8),
              _buildLegendItem("Product B", Colors.blue),
              const SizedBox(width: 8),
              _buildLegendItem("Product C", Colors.purple),
              const SizedBox(width: 8),
              _buildLegendItem("Product D", Colors.indigo),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 800,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      // Chỉ hiển thị tooltip cho cột đầu tiên trong nhóm (rodIndex == 0)

                      // Lấy dữ liệu của tất cả các cột trong nhóm (tháng)
                      final rods = group.barRods;
                      final month = ['Jan', 'Feb', 'Mar', 'Apr'][groupIndex];

                      // Tạo danh sách TextSpan cho tất cả sản phẩm
                      List<TextSpan> tooltipItems = [];
                      for (int i = 0; i < rods.length; i++) {
                        String product;
                        Color color;
                        switch (i) {
                          case 0:
                            product = "Product A";
                            color = Colors.teal;
                            break;
                          case 1:
                            product = "Product B";
                            color = Colors.blue;
                            break;
                          case 2:
                            product = "Product C";
                            color = Colors.purple;
                            break;
                          case 3:
                            product = "Product D";
                            color = Colors.indigo;
                            break;
                          default:
                            product = "";
                            color = Colors.grey;
                        }
                        tooltipItems.add(
                          TextSpan(
                            text: '● ',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                            ),
                          ),
                        );
                        tooltipItems.add(
                          TextSpan(
                            text: '$product \$${rods[i].toY.toInt()}\n',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }

                      return BarTooltipItem(
                        '$month\n',
                        const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        children: tooltipItems,
                      );
                    },
                    getTooltipColor: (group) => Colors.white,
                  ),
                  handleBuiltInTouches: true,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return const Text('Jan', style: style);
                          case 1:
                            return const Text('Feb', style: style);
                          case 2:
                            return const Text('Mar', style: style);
                          case 3:
                            return const Text('Apr', style: style);
                          default:
                            return const Text('', style: style);
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0, // Jan
                    barRods: [
                      BarChartRodData(toY: 400, color: Colors.teal, width: 15),
                      BarChartRodData(toY: 300, color: Colors.blue, width: 15),
                      BarChartRodData(toY: 500, color: Colors.purple, width: 15),
                      BarChartRodData(toY: 200, color: Colors.indigo, width: 15),
                    ],
                    showingTooltipIndicators: [], // Không hiển thị tooltip ban đầu
                  ),
                  BarChartGroupData(
                    x: 1, // Feb
                    barRods: [
                      BarChartRodData(toY: 450, color: Colors.teal, width: 15),
                      BarChartRodData(toY: 350, color: Colors.blue, width: 15),
                      BarChartRodData(toY: 550, color: Colors.purple, width: 15),
                      BarChartRodData(toY: 250, color: Colors.indigo, width: 15),
                    ],
                    showingTooltipIndicators: [], // Không hiển thị tooltip ban đầu
                  ),
                  BarChartGroupData(
                    x: 2, // Mar
                    barRods: [
                      BarChartRodData(toY: 500, color: Colors.teal, width: 15),
                      BarChartRodData(toY: 400, color: Colors.blue, width: 15),
                      BarChartRodData(toY: 400, color: Colors.purple, width: 15),
                      BarChartRodData(toY: 300, color: Colors.indigo, width: 15),
                    ],
                    showingTooltipIndicators: [], // Không hiển thị tooltip ban đầu
                  ),
                  BarChartGroupData(
                    x: 3, // Apr
                    barRods: [
                      BarChartRodData(toY: 450, color: Colors.teal, width: 15),
                      BarChartRodData(toY: 350, color: Colors.blue, width: 15),
                      BarChartRodData(toY: 550, color: Colors.purple, width: 15),
                      BarChartRodData(toY: 200, color: Colors.indigo, width: 15),
                    ],
                    showingTooltipIndicators: [], // Không hiển thị tooltip ban đầu
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Hàm tạo mục chú thích
Widget _buildLegendItem(String title, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}