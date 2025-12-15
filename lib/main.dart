import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uas_themonitor/Screens/login/login_screen.dart';
import 'package:uas_themonitor/Screens/settings/settings_screen.dart'; // Jika ada tombol settings/logout
import 'package:uas_themonitor/providers/auth_providers.dart';
import 'package:uas_themonitor/database/db_helper.dart';
import 'package:uas_themonitor/Screens/add_report_screen.dart';
import 'package:uas_themonitor/Screens/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DbHelper();

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

      home: const AuthWrapper(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/add': (context) => const AddReportScreen(),
        '/settings': (context) => const SettingsScreen(),

        // Halaman otentikasi
        '/login': (context) => const LoginScreen(),
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

// 4. Widget baru yang memeriksa status login menggunakan Riverpod
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Memantau status otentikasi
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    //

    // Jika sudah login, tampilkan DashboardScreen
    if (isAuthenticated) {
      return const DashboardScreen();
    }
    // Jika belum login, tampilkan LoginScreen
    else {
      return const LoginScreen();
    }
  }
}
