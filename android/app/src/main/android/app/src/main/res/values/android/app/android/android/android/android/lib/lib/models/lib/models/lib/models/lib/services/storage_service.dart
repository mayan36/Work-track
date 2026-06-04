import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_data.dart';

class StorageService {
  static const String _key = 'work_track_data';
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<AppData> loadData() async {
    final json = _prefs!.getString(_key);
    if (json == null) return AppData.empty();
    try {
      return AppData.fromJson(json);
    } catch (_) {
      return AppData.empty();
    }
  }

  Future<void> saveData(AppData data) async {
    await _prefs!.setString(_key, data.toJson());
  }
}
