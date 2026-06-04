import 'dart:convert';
import 'task.dart';
import 'day_record.dart';

class AppData {
  List<Task> tasks;
  int currentStreak;
  int longestStreak;
  int streakThreshold;
  List<DayRecord> history;
  String? lastRecordedDate;

  AppData({
    required this.tasks,
    required this.currentStreak,
    required this.longestStreak,
    required this.streakThreshold,
    required this.history,
    this.lastRecordedDate,
  });

  factory AppData.empty() {
    return AppData(
      tasks: [],
      currentStreak: 0,
      longestStreak: 0,
      streakThreshold: 80,
      history: [],
      lastRecordedDate: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'streakThreshold': streakThreshold,
      'history': history.map((h) => h.toMap()).toList(),
      'lastRecordedDate': lastRecordedDate,
    };
  }

  factory AppData.fromMap(Map<String, dynamic> map) {
    return AppData(
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((t) => Task.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [],
      currentStreak: map['currentStreak'] as int? ?? 0,
      longestStreak: map['longestStreak'] as int? ?? 0,
      streakThreshold: map['streakThreshold'] as int? ?? 80,
      history: (map['history'] as List<dynamic>?)
              ?.map((h) => DayRecord.fromMap(h as Map<String, dynamic>))
              .toList() ??
          [],
      lastRecordedDate: map['lastRecordedDate'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AppData.fromJson(String source) =>
      AppData.fromMap(jsonDecode(source));

  double get totalWeight =>
      tasks.fold(0.0, (sum, t) => sum + t.weight);

  double get completedWeight =>
      tasks.where((t) => t.isCompleted).fold(0.0, (sum, t) => sum + t.weight);

  double get completionPercentage {
    if (totalWeight == 0) return 0.0;
    return (completedWeight / totalWeight) * 100;
  }
}
