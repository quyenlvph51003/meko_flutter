import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();

  static SharedPref? _instance;

  static SharedPref get instance {
    _instance ??= SharedPref._();
    return _instance!;
  }

  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? result = prefs.getString(key);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? result = prefs.getBool(key);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? result = prefs.getInt(key);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double? result = prefs.getDouble(key);
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
