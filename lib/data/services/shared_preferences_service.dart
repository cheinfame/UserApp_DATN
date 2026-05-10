import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService({required SharedPreferences prefs}) : _prefs = prefs;

  // Store a string value
  Future<bool> setStringValue(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Retrieve a string value
  String? getStringValue(String key) {
    return _prefs.getString(key);
  }

  // Store a boolean value
  Future<bool> setBoolValue(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Retrieve a boolean value
  bool? getBoolValue(String key) {
    return _prefs.getBool(key);
  }

  // Store an integer value
  Future<bool> setIntValue(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // Retrieve an integer value
  int? getIntValue(String key) {
    return _prefs.getInt(key);
  }

  // Store a double value
  Future<bool> setDoubleValue(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // Retrieve a double value
  double? getDoubleValue(String key) {
    return _prefs.getDouble(key);
  }

  // Remove a preference
  Future<bool> removeValue(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all preferences
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
