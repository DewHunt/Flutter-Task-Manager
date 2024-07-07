import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController {
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';
  static const String _verifiedEmail = 'verify-email';
  static const String _verifiedOtp = 'verify-otp';
  static String accessToken = '';
  static UserModel? userData;

  static Future<void> saveUserAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey);
  }

  static Future<void> saveUserData(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));
    userData = user;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(_userDataKey);
    if (data == null) return null;
    UserModel user = UserModel.fromJson(jsonDecode(data));
    return user;
  }

  static Future<bool> checkAuthStatus() async {
    String? token = await getUserAccessToken();
    if (token == null) return false;
    accessToken = token;
    userData = await getUserData();
    return true;
  }

  static Future<void> saveVerifiedEmail(email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_verifiedEmail, email);
  }

  static Future<String?> getVerifiedEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_verifiedEmail);
  }

  static Future<void> saveVerifyOtp(otp) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_verifiedOtp, otp);
  }

  static Future<String?> getVerifiedOtp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_verifiedOtp);
  }

  static Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}