import 'dart:convert';

import 'package:computer_sales_app/services/user.service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _phone;
  String? _name;
  String? _role;
  String? _address;
  int? _point;

  String? get id => _id;
  String? get phone => _phone;
  String? get name => _name;
  String? get role => _role;
  String? get address => _address;
  int? get point => _point;

  final userService = UserService();

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setUser(userMap);
    }
  }

  void setUser(Map<String, dynamic> user) {
    _id = user['id'];
    _phone = user['phone'];
    _name = user['name'];
    _role = user['role'];
    _point = user['point'];
    _address = user['address'];
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void clearUser() {
    _id = null;
    _phone = null;
    _name = null;
    _role = null;
    _point = null;
    _address = null;
    notifyListeners();
  }
}
