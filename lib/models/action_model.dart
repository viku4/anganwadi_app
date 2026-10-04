class ActionTileData {
  final String? title;
  final String? icon;
  final String? backgroundColor;
  final String? routes;

  ActionTileData({this.title, this.icon, this.backgroundColor, this.routes});

  factory ActionTileData.fromJson(Map<String, dynamic> json) {
    return ActionTileData(
      title: json['name'] ?? '',
      icon: json['icon'] ?? '',
      backgroundColor: json['color'] ?? '',
      routes: json['url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'icon': icon,
      'color': backgroundColor,
      'url': routes,
    };
  }
}
