import 'package:anganwadi_connect/models/role_model.dart';

class LoginModel {
  String? sId;
  String? name;
  RoleModel? roleId;
  String? username;
  String? phone;
  String? email;
  String? password;
  int? status;
  String? createdBy;
  String? updatedBy;
  String? createdAt;  
  String? updatedAt;

  LoginModel({
    this.sId, 
    this.name,
    this.roleId,
    this.username,
    this.phone,
    this.email,
    this.password,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    roleId = json['roleId'] != null ? RoleModel.fromJson(json['roleId']) : null;
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (roleId != null) {
      data['roleId'] = roleId!.toJson();
    }
    data['username'] = username;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
