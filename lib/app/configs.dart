import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  Future<dynamic> read(String key, {dynamic defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();
    if (defaultValue is bool) {
      return prefs.getBool(key) ?? defaultValue;
    } else if (defaultValue is int) {
      return prefs.getInt(key) ?? defaultValue;
    } else if (defaultValue is double) {
      return prefs.getDouble(key) ?? defaultValue;
    } else if (defaultValue is String) {
      return prefs.getString(key) ?? defaultValue;
    } else if (defaultValue is List<String>) {
      return prefs.getStringList(key) ?? defaultValue;
    }
    return Future.value(null);
  }

  Future<bool> write(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is String) {
      return prefs.setString(key, value);
    } else if (value is List<String>) {
      return prefs.setStringList(key, value);
    }
    return Future.value(false);
  }
}
