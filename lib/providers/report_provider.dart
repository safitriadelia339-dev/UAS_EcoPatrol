import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_themonitor/models/report_model.dart';
import 'package:uas_themonitor/database/db_helper.dart';

class ReportNotifier extends StateNotifier<List<ReportModel>> {
  final DbHelper _dbHelper = DbHelper();
  static const String _tableName = 'reports';

  ReportNotifier() : super([]) {
    _loadReports(); // Muat data saat provider diinisialisasi
  }

  // Memuat laporan dari SQLite
  Future<void> _loadReports() async {
    final dataList = await _dbHelper.getReports(_tableName);
    state = dataList.map((map) => ReportModel.fromJson(map)).toList();
  }

  // Menambahkan laporan ke state dan SQLite
  Future<void> addReport(ReportModel report) async {
    // 1. Simpan ke database
    await _dbHelper.insertReport(_tableName, report.toJson());

    // 2. Perbarui state
    state = [...state, report];
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, List<ReportModel>>(
  (ref) => ReportNotifier(),
);
