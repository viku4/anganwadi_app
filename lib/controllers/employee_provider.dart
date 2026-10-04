import 'dart:developer';

import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/models/login_model.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:flutter/material.dart';

EmployeeProvider employeeProvider = EmployeeProvider();

class EmployeeProvider extends ChangeNotifier {
  List<LoginModel> _employeeList = [];

  List<LoginModel> get employeeList => _employeeList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setLoadingIn(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set setEmployeeList(List<LoginModel>? employeeList) {
    _employeeList = employeeList ?? [];
    notifyListeners();
  }

  Future fetchEmployeeList() async {
    setLoadingIn = true;
    try {
      final data = await ApiClient().request(
        path: usersUrl,
        method: RequestMethod.post,
      );
      if (data is List) {
        setEmployeeList = List.from(data.map((e) => LoginModel.fromJson(e)));
      } else {
        setEmployeeList = [];
      }
    } catch (e) {
      log("fetchEmployeeList Error :$e");
    } finally {
      setLoadingIn = false;
    }
    notifyListeners();
  }

  Future setAndUpdateGuest({required Object payload}) async {
    setLoadingIn = true;
    try {
      final data = await ApiClient().request(
        path: useAddAndUpdatesUrl,
        method: RequestMethod.post,
        payload: payload,
      );
      if (data is Map) {
        await fetchEmployeeList();
        RoutingService().goBack();
      }
      log("message");
    } catch (e) {
      log("setAndUpdateGuest Error :$e");
    } finally {
      setLoadingIn = false;
    }
  }
}
