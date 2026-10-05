import 'dart:developer';

import 'package:anganwadi_connect/models/state_dictrict_bloc_model.dart';
import 'package:anganwadi_connect/services/network/api_client.dart';
import 'package:anganwadi_connect/services/network/api_endpoints.dart';
import 'package:flutter/material.dart';

HomeProvider homeProvider = HomeProvider();

class HomeProvider extends ChangeNotifier {
  List<StateDictrictBlocModel> _states = [];
  List<StateDictrictBlocModel> get states => _states;
  List<StateDictrictBlocModel> _dictricts = [];
  List<StateDictrictBlocModel> get dictricts => _dictricts;
  List<StateDictrictBlocModel> _blocks = [];
  List<StateDictrictBlocModel> get blocks => _blocks;
  List<StateDictrictBlocModel> _villages = [];
  List<StateDictrictBlocModel> get villages => _villages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future getStates() async {
    setLoading = true;
    try {
      final data = await ApiClient().request(
        path: statesUrl,
        method: RequestMethod.get,
      );
      if (data is List) {
        _states = List.from(
          data.map((e) => StateDictrictBlocModel.fromJson(e)),
        );
      } else {
        _states = [];
      }
    } catch (e) {
      log("getState Error :$e");
    } finally {
      setLoading = false;
    }
  }

  Future getDistricts({String? stateId}) async {
    setLoading = true;
    try {
      final data = await ApiClient().request(
        path: districtsUrl,
        method: RequestMethod.post,
        payload: {"state_id": stateId},
      );
      if (data is List) {
        _dictricts = List.from(
          data.map((e) => StateDictrictBlocModel.fromJson(e)),
        );
      } else {
        _dictricts = [];
      }
    } catch (e) {
      log("getDistricts Error :$e");
    } finally {
      setLoading = false;
    }
  }

  Future getBlocks({String? stateId, String? districtId}) async {
    setLoading = true;
    try {
      final data = await ApiClient().request(
        path: blocksUrl,
        method: RequestMethod.post,
        payload: {"state_id": stateId, "district_id": districtId},
      );
      if (data is List) {
        _blocks = List.from(
          data.map((e) => StateDictrictBlocModel.fromJson(e)),
        );
      } else {
        _blocks = [];
      }
    } catch (e) {
      log("getDistricts Error :$e");
    } finally {
      setLoading = false;
    }
  }

  Future getVillages({
    String? stateId,
    String? districtId,
    String? blockId,
  }) async {
    setLoading = true;
    try {
      final data = await ApiClient().request(
        path: villagesUrl,
        method: RequestMethod.post,
        payload: {
          "state_id": stateId,
          "district_id": districtId,
          "block_id": blockId,
        },
      );
      if (data is List) {
        _villages = List.from(
          data.map((e) => StateDictrictBlocModel.fromJson(e)),
        );
      } else {
        _villages = [];
      }
    } catch (e) {
      log("getDistricts Error :$e");
    } finally {
      setLoading = false;
    }
  }
}
