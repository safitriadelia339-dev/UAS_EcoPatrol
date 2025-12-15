import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

class ReportNotifier extends StateNotifier<List<ReportModel>> {
  ReportNotifier() : super([]);

  void addReport(ReportModel report) {
    state = [...state, report];
  }
}

final reportProvider =
StateNotifierProvider<ReportNotifier, List<ReportModel>>(
      (ref) => ReportNotifier(),
);
