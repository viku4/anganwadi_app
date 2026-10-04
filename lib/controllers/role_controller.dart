import 'dart:developer';

import 'package:anganwadi_connect/models/role_model.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:flutter/material.dart';

RoleController roleController = RoleController();

class RoleController extends ChangeNotifier {
  List<RoleModel> _getRole = [];
  bool _isLoading = false;

  List<RoleModel> get getRole => _getRole;
  bool get isLoading => _isLoading;

  set setLoading(bool data) {
    _isLoading = data;
    notifyListeners();
  }

  Future getRoles() async {
    try {
      setLoading = true;
      var response = await ApiClient().request(
        path: rolesUrl,
        method: RequestMethod.get,
      );
      if (response is List) {
        _getRole = List.from(
          response.map((e) => RoleModel.fromJson(Map<String, dynamic>.from(e))),
        );
      } else {
        _getRole = [];
      }
    } catch (e) {
      log("catch :- ${e.toString()}");
    }
    setLoading = false;

    notifyListeners();
  }
}
