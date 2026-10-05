import 'dart:developer';

import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:flutter/material.dart';

AnganwadiProvider anganwadiProvider = AnganwadiProvider();

class AnganwadiProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future createAnganwadi({required Object payload}) async {
    setLoading = true;
    try {
      final data = await ApiClient().request(
        path: anganwadiCreateUrl,
        method: RequestMethod.post,
        payload: payload,
      );
      if (data is Map && data.isNotEmpty) {
        RoutingService().goBack();
      }
    } catch (e) {
      log("createAnganwadi Error :$e");
    } finally {
      setLoading = false;
    }
    notifyListeners();
  }
}
