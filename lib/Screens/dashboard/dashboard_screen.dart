import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/report_provider.dart';
import '../../widgets/report_item.dart';
import 'summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportProvider); // ambil list laporan realtime

    final total = reports.length;
    final selesai = reports.where((r) => r.status == "done").length;
    final pending = total - selesai;

    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoPatrol Dashboard"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔹 SUMMARY DI ATAS
            SummaryCard(
              total: total,
              pending: pending,
              selesai: selesai,
            ),

            const SizedBox(height: 16),

            /// 🔹 LIST LAPORAN (Realtime)
            Expanded(
              child: reports.isEmpty
                  ? const Center(
                child: Text("Belum ada laporan"),
              )
                  : ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];

                  return ReportItem(
                    report: report,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/detail",
                        arguments: report,
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
