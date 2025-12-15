import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_themonitor/providers/report_provider.dart';
import '../../models/report_model.dart';


class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;

  const DetailReportScreen({
    super.key,
    required this.report,
  });

  Future<void> _deleteReport(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Laporan'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus laporan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(reportProvider.notifier).deleteReport(report.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteReport(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STATUS
            Text(
              report.status.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: report.status == "done"
                    ? Colors.green
                    : Colors.orange,
              ),
            ),

            const SizedBox(height: 12),

            /// JUDUL
            Text(
              report.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// DESKRIPSI
            Text(
              report.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            /// FOTO
            const Text(
              'Foto Bukti:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(report.imagePath),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// LOKASI
            const Text(
              'Lokasi:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Latitude : ${report.latitude}'),
            Text('Longitude: ${report.longitude}'),
          ],
        ),
      ),
    );
  }
}