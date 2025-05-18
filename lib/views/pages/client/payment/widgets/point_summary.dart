import 'package:flutter/material.dart';

class PointSummary extends StatelessWidget {
  final double currentPoints;
  final double pointsToUse;
  final double pointsToReceive;

  const PointSummary({
    super.key,
    required this.currentPoints,
    required this.pointsToUse,
    required this.pointsToReceive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: const Text(
                'Point Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Text(
                'You can only use points up to 50% !',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 250, 31, 15),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            _buildRow('Current Points',
                '${currentPoints.toStringAsFixed(0)} Points', Colors.black),
            _buildRow('Points Used', '${pointsToUse.toStringAsFixed(0)} Points',
                Colors.black),
            _buildRow('Points Earned',
                '${pointsToReceive.toStringAsFixed(0)} Points', Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}
