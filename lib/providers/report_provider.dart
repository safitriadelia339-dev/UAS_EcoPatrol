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

  // --- Method yang ditambahkan: deleteReport ---
  Future<void> deleteReport(String id) async {
    // 1. Hapus dari database SQLite
    // Anda perlu memastikan DbHelper memiliki method deleteReport
    await _dbHelper.deleteReport(_tableName, id);

    // 2. Perbarui state lokal (hapus dari list)
    // Kami membuat list baru yang hanya berisi laporan yang ID-nya TIDAK sama dengan ID yang dihapus.
    state = state.where((report) => report.id != id).toList();
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, List<ReportModel>>(
      (ref) => ReportNotifier(),
);