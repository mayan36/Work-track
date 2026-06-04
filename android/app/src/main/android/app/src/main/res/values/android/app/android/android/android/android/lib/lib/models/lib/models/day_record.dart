import 'dart:convert';

class DayRecord {
  final String date;
  final double completionPercentage;

  DayRecord({
    required this.date,
    required this.completionPercentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'completionPercentage': completionPercentage,
    };
  }

  factory DayRecord.fromMap(Map<String, dynamic> map) {
    return DayRecord(
      date: map['date'] as String,
      completionPercentage: (map['completionPercentage'] as num).toDouble(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory DayRecord.fromJson(String source) =>
      DayRecord.fromMap(jsonDecode(source));
}
