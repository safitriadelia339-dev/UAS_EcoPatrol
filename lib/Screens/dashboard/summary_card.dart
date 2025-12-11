import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int total;
  final int pending;
  final int selesai;

  const SummaryCard({
    super.key,
    required this.total,
    required this.pending,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem("Total", total, Colors.blue),
            _buildItem("Pending", pending, Colors.red),
            _buildItem("Selesai", selesai, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label),
      ],
    );
  }
}
