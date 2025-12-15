import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_themonitor/providers/auth_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null)
              Text(
                'Selamat datang, ${user.username}!',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            if (user != null)
              ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout Berhasil')),
                  );
                },
                child: const Text('Logout'),
              )
            else
              const Text('Anda belum login.'),
          ],
        ),
      ),
    );
  }
}
