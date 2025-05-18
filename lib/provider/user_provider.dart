import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/services/user.service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  final userService = UserService();

  Future<void> loadUserData() async {
    //check if user is logged in
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      return;
    }

    final data = await userService.getUserInfoById();
    userModel = UserModel(
        id: data.id,
        email: data.email,
        phone: data.phone,
        fullName: data.fullName,
        address: data.address,
        avatar: data.avatar,
        role: data.role,
        loyaltyPoints: data.loyaltyPoints,
        isActive: data.isActive);

    notifyListeners();
  }

  void setUser(Map<String, dynamic> user) {
    userModel = UserModel(
      id: user['_id'],
      email: user['email'],
      phone: user['phone'],
      fullName: user['name'],
      address: user['address'] ?? '',
      avatar: UserImage.fromJson(user['avatar']),
      role: user['role'],
      loyaltyPoints: user['loyalty_points'] ?? 0.0,
      isActive: user['isActive'] ?? true,
    );

    notifyListeners();
  }

  void clearUser() {
    userModel = null;
    notifyListeners();
  }
}

class AvatarUser {
  String? url;
  String? publicId;

  AvatarUser({this.url, this.publicId});
  AvatarUser.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['public_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['public_id'] = publicId;
    return data;
  }
}
