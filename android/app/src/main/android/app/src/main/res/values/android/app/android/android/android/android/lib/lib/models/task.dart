import 'dart:convert';

class Task {
  final String id;
  String name;
  double weight;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.weight,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      name: map['name'] as String,
      weight: (map['weight'] as num).toDouble(),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(jsonDecode(source));

  Task copyWith({
    String? id,
    String? name,
    double? weight,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
