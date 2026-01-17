import 'package:shared_preferences/shared_preferences.dart';

//enum LocalStorageKey { username, email, password, login, logout, darktheme }

enum LocalStorageKey { darktheme }

class LocalStorageService {
  static final _instance = LocalStorageService._();

  // instance for shared preferences
  final _prefs = SharedPreferencesAsync();

  // private constructor
  LocalStorageService._();

  // factory constructor
  factory LocalStorageService() => _instance;

  // set username
  // Future<void> setusername(String value) async {
  //   await _prefs.setString(LocalStorageKey.username.name, value);
  // }

  // // set email
  // Future<void> setemail(String value) async {
  //   await _prefs.setString(LocalStorageKey.email.name, value);
  // }

  // // set password
  // Future<void> serpassword(dynamic value) async {
  //   await _prefs.setString(LocalStorageKey.password.name, value);
  // }

  // //setlogin status
  // Future<void> setLoginStatus(bool value) async {
  //   await _prefs.setBool(LocalStorageKey.login.name, value);
  // }

  Future<void> setdarktheme(bool value) async {
    await _prefs.setBool(LocalStorageKey.darktheme.name, value);
  }

  Future<bool> getdarktheme() async {
    return await _prefs.getBool(LocalStorageKey.darktheme.name) ?? false;
  }

  // // get login status
  // Future<bool> getLoginStatus() async {
  //   return await _prefs.getBool(LocalStorageKey.login.name) ?? false;
  // }

  // // clear key value
  // Future<void> clearData() async {
  //   await _prefs.clear();
  // }

  // Future<dynamic> getEmail() async {
  //   return await _prefs.getBool(LocalStorageKey.email.name) ?? false;
  // }

  // Future<dynamic> getUsername() async {
  //   return await _prefs.getBool(LocalStorageKey.email.name) ?? false;
  // }
}
