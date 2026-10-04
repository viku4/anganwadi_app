class RoleModel {
  String? id;
  String? name;
  String? slug;
  int? status;
  String? createdAt;
  String? updatedAt;

  RoleModel({
    this.id,
    this.name,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  RoleModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    slug = json['slug'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
