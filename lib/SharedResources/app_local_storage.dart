import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  late final SharedPreferences _pref;
  Future<AppLocalStorage> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  Future<void> setDoctorId(String key, int value) async {
    await _pref.setInt(key, value);
  }
  Future<void> setPatientId(String key, int value) async {
    await _pref.setInt(key, value);
  }

  String getString(String key) {
    return _pref.getString(key) ?? "";
  }

  int getInt(String key) {
    return _pref.getInt(key) ?? 0;
  }

  bool getBool(String key) {
    return _pref.getBool(key) ?? false;
  }

  void remove(String key) {
    _pref.remove(key);
  }
}
