import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController {
  static const String _accessTokenKey = 'access-token';
  static const String _resetEmail = 'reset-email';
  static const String _otp = 'otp';
  static const String _userDataKey = 'user';

  static String? accessToken;
  static String? resetEmail;
  static String? otp;
  static UserModel? userData;

  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<void> saveUserData(UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData = userModel;
  }

  static Future<void> saveResetEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_resetEmail, email);
    resetEmail = email;
  }
  static Future<void> saveOtp(String otpP) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_otp, otpP);
    otp = otpP;
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    accessToken = token;
    return token;
  }
  static Future<String?> getResetEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? resetEmailC = sharedPreferences.getString(_resetEmail);
    resetEmail = resetEmailC;
    return resetEmailC;
  }
  static Future<String?> getOtp() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? otpC = sharedPreferences.getString(_otp);
    otp = otpC;
    return otpC;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodedData = sharedPreferences.getString(_userDataKey);
    if (userEncodedData == null) {
      return null;
    }
    UserModel userModel = UserModel.fromJson(jsonDecode(userEncodedData));
    userData = userModel;
    return userModel;
  }

  static bool isUserLoggedIn() {
    return accessToken != null;
  }

  static Future<void> removeAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
  }

  static Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
