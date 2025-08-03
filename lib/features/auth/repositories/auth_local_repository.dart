import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart'; // علشان ناخد sharedPreferencesProvider

class AuthLocalRepository {
  final SharedPreferences _sharedPreferences;

  AuthLocalRepository(this._sharedPreferences);

  void setToken(String? token) {
    if (token != null) {
      _sharedPreferences.setString('x_auth_token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x_auth_token');
  }
}

final authLocalRepositoryProvider = Provider<AuthLocalRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalRepository(prefs);
});
