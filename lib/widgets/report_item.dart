import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportItem extends StatelessWidget {
  final ReportModel report;
  final VoidCallback onTap;

  const ReportItem({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = report.status == "done";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(report.title),
        subtitle: Text(report.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDone ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isDone ? "Selesai" : "Pending",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
