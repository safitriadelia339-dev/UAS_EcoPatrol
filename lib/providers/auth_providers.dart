import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uas_themonitor/database/db_helper.dart';
import 'package:uas_themonitor/models/user_model.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null); // UserModel? (null jika belum login)

  final DbHelper _dbHelper = DbHelper();

  Future<bool> login(String username, String password) async {
    final userData = await _dbHelper.authenticateUser(username, password);

    if (userData != null) {
      state = UserModel(
        id: userData['id'] as int,
        username: userData['username'] as String,
      );
      return true;
    }
    state = null;
    return false;
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>(
  (ref) => AuthNotifier(),
);

// Provider untuk mengecek status login
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) != null;
});
