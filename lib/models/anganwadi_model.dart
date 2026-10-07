import 'package:anganwadi_connect/models/state_dictrict_bloc_model.dart';

class AnganwadiModel {
  String? id;
  String? name;
  String? code;
  String? latitude;
  String? longitude;
  String? address;
  int? status;
  StateDictrictBlocModel? stateId;
  StateDictrictBlocModel? districtId;
  StateDictrictBlocModel? blockId;
  StateDictrictBlocModel? villageId;

  AnganwadiModel({
    this.id,
    this.name,
    this.code,
    this.latitude,
    this.longitude,
    this.address,
    this.status,
    this.stateId,
    this.districtId,
    this.blockId,
    this.villageId,
  });

  AnganwadiModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    code = json['code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = json['status'];
    stateId = json['stateId'] is Map
        ? StateDictrictBlocModel.fromJson(json['stateId'])
        : null;
    districtId = json['districtId'] is Map
        ? StateDictrictBlocModel.fromJson(json['districtId'])
        : null;
    blockId = json['blockId'] is Map
        ? StateDictrictBlocModel.fromJson(json['blockId'])
        : null;
    villageId = json['villageId'] is Map
        ? StateDictrictBlocModel.fromJson(json['villageId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['status'] = status;
    data['stateId'] = stateId?.toJson();
    data['districtId'] = districtId?.toJson();
    data['blockId'] = blockId?.toJson();
    data['villageId'] = villageId?.toJson();

    return data;
  }
}
