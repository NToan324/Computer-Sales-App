import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _phone;
  String? _name;
  String? _role;
  int? _point;

  String? get id => _id;
  String? get phone => _phone;
  String? get name => _name;
  String? get role => _role;
  int? get point => _point;

  void setUser(Map<String, dynamic> user) {
    _id = user['id'];
    _phone = user['phone'];
    _name = user['name'];
    _role = user['role'];
    _point = user['point'];
    notifyListeners();
  }

  void clearUser() {
    _id = null;
    _phone = null;
    _name = null;
    _role = null;
    _point = null;
    notifyListeners();
  }
}
