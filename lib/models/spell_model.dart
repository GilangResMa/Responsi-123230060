class Spells {
  final int? index;
  final String? spell;
  final String? use;

  Spells({
    required this.index,
    required this.spell,
    required this.use
  });

  factory Spells.fromJson(Map<String, dynamic> json) {
    return Spells(
      index: json['index'] ?? '',
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'spell': spell,
      'use': use,
    };
  }
}
