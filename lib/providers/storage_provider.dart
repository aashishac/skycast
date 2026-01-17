import 'package:flutter/material.dart';
import 'package:skycast/services/local_storage_service.dart';

class StorageProvider extends ChangeNotifier {
  final storageService = LocalStorageService();

  // bool _isLoggedIn = false;
  // bool _isLoading = false;
  bool _isdarkthme = false;
  // String _username = '';
  // String _email = '';

  // bool get isLoggedIn => _isLoggedIn;
  // bool get isLoading => _isLoading;
  // String get username => _username;
  // String get email => _email;
  bool get isDarktheme => _isdarkthme;
  StorageProvider() {
    _init();
  }

  Future<void> _init() async {
    await getdarktheme();
    //getLoginStatus();
    // _username = await storageService.getUsername() ?? '';
    // _email = await storageService.getEmail() ?? '';

    notifyListeners();
  }

  // Future<void> setUsername(String value) async {
  //   _username = value;
  //   await storageService.setusername(value); // ✅ persist to local storage
  //   notifyListeners();
  // }

  // Future<void> setEmail(String value) async {
  //   _email = value;
  //   await storageService.setemail(value); // ✅ persist to local storage
  //   notifyListeners();
  // }

  Future<void> setdarktheme(bool value) async {
    _isdarkthme = value;
    await storageService.setdarktheme(value); // ✅ persist to local storage
    notifyListeners();
  }

  // Future<void> setLoginStatus(bool value) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   // simulate API call
  //   await Future.delayed(const Duration(seconds: 3));

  //   _isLoggedIn = value;
  //   _isLoading = false;
  //   notifyListeners();

  //   await storageService.setLoginStatus(value); // ✅ persist login status
  // }

  // Future<void> getLoginStatus() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   _isLoggedIn = await storageService.getLoginStatus();

  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> getdarktheme() async {
    _isdarkthme = await storageService.getdarktheme();
    notifyListeners();
  }

  // //  fetch username
  // Future<void> getUsername() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   _username = await storageService.getUsername() ?? '';

  //   _isLoading = false;
  //   notifyListeners();
  // }

  // //  fetch email
  // Future<void> getEmail() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   _email = await storageService.getEmail() ?? '';

  //   _isLoading = false;
  //   notifyListeners();
}

  // Future<void> clearData() async {
  //   await storageService.clearData();
  //   _isLoggedIn = false;
  //   _username = '';
  //   _email = '';
  //   notifyListeners();
  // }

