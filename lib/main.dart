import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/add_report_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoPatrol',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),

      // Kalau ada login, ganti jadi '/login'
      initialRoute: '/',

      //ROUTES (Daftar semua halaman)
      routes: {
        '/': (context) => const DashboardScreen(), // Home/Dashboard
        '/add': (context) =>
            const AddReportScreen(), // Tambah Laporan (Mahasiswa 2)
      },

      //ON GENERATE ROUTE (untuk route dengan arguments)
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final report =
              settings.arguments; // arguments dari Navigator.pushNamed
          // return MaterialPageRoute(
          //   builder: (context) => DetailReportScreen(report: report),
          // );
        }
        return null;
      },
    );
  }
}
