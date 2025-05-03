import 'dart:convert';

import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/services/base_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends BaseClient {
  Future<void> loadUserData(UserProvider userProvider) async {
    final prefs = await SharedPreferences.getInstance();

    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      userProvider.setUser(userMap);
    }
  }
}
