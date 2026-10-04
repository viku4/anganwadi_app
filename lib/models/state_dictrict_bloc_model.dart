class StateDictrictBlocModel {
  String? id;
  String? name;

  StateDictrictBlocModel({this.id, this.name});

  StateDictrictBlocModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    return data;
  }
}
