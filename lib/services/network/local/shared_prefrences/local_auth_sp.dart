import 'dart:convert';

import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/main.dart';
import 'package:anganwadi_connect/models/login_model.dart';

const String userKey = 'CURRENT_USER';
const String tokenKey = 'CURRENT_USER_ACCESS_TOKEN';
const String refreshTokenKey = 'CURRENT_USER_ACCESS_REFRESH_TOKEN';

class AuthStorage {
  static Future<void> setUser(LoginModel data) async {
    await prefs.setString(userKey, jsonEncode(data.toJson()));
  }

  static Future getUser() async {
    final raw = prefs.getString(userKey);
    if (raw == null || raw.isEmpty) return null;

    final data = jsonDecode(raw) as Map<String, dynamic>;
    final user = LoginModel.fromJson(data);

    loginProvider.updateData(loginModel: user);
  }

  static Future<void> setUserAccessToken(String token) async {
    await prefs.setString(tokenKey, token);
  }

  static Future getUserAccessToken() async {
    final token = prefs.getString(tokenKey);

    if (token == null || token.isEmpty) return null;

    loginProvider.updateTokenData(accessToken: token);
  }

  static Future<void> setUserRefreshAccessToken(String token) async {
    await prefs.setString(refreshTokenKey, token);
  }

  static Future getUserRefreshAccessToken() async {
    final token = prefs.getString(refreshTokenKey);

    if (token == null || token.isEmpty) return null;

    loginProvider.updateTokenData(refreshToken: token);
  }
}
