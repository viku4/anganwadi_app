import 'dart:developer';

import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/models/login_model.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:anganwadi_connect/services/network/local/shared_prefrences/local_auth_sp.dart';
import 'package:flutter/material.dart';

LoginProvider loginProvider = LoginProvider();

class LoginProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  LoginModel? _loginModel;
  LoginModel? get loginModel => _loginModel;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void updateTokenData({String? accessToken, String? refreshToken}) {
    if (accessToken != null) {
      _accessToken = accessToken;
    }
    if (refreshToken != null) {
      _refreshToken = refreshToken;
    }
    notifyListeners();
  }

  void updateData({LoginModel? loginModel}) {
    if (loginModel != null) {
      _loginModel = loginModel;
    }
    notifyListeners();
  }

  Future login({required String username, required String password}) async {
    setLoggedIn = true;

    try {
      final data = await ApiClient().request(
        path: loginUrl,
        method: RequestMethod.post,
        payload: {"username": username, "password": password},
      );
      if (data is Map &&
          data.containsKey('user') &&
          data.containsKey('accessToken') &&
          data.containsKey('refreshToken')) {
        final accessToken = data['accessToken']?.toString();
        final refreshToken = data['refreshToken']?.toString();
        if (data['user'] is Map &&
            accessToken != null &&
            refreshToken != null) {
          final userJson = Map<String, dynamic>.from(data['user']);
          final user = LoginModel.fromJson(userJson);
          await AuthStorage.setUserAccessToken(accessToken);
          await AuthStorage.setUserRefreshAccessToken(refreshToken);
          await AuthStorage.setUser(user);
          updateTokenData(accessToken: accessToken, refreshToken: refreshToken);
          updateData(loginModel: user);
          RoutingService().go(Routes.homeScreen.name);
        } else {
          log(" 🚫 Login error: Invalid user data format");
        }
      } else {
        log("🚫 Login error: Invalid response format");
      }
    } catch (e) {
      log("🚫 Login error: $e");
    } finally {
      setLoggedIn = false;
    }

    notifyListeners();
  }

  void logout() {
    _accessToken = null;
    _refreshToken = null;
    _loginModel = null;
    notifyListeners();
  }
}
