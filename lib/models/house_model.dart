class HouseModel {
  final String id;
  final String name;
  final String founder;
  final String emoji;

  HouseModel({
    required this.id,
    required this.name,
    required this.founder,
    required this.emoji,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      founder: json['founder'] ?? '',
      emoji: json['emoji'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'founder': founder,
      'emoji': emoji,
    };
  }
}
