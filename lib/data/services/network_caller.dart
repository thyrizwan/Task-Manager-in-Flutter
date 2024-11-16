import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/ui/controllers/shared_preference_controller.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> curHeaders = {
        'Content-Type': 'application/json',
        'token': SharedPreferenceController.accessToken.toString(),
      };
      debugPrint('Calling URL: $uri');
      final Response response = await get(
        uri,
        headers: curHeaders,
      );

      printResponse(uri.toString(), response);

      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else if (response.statusCode == 401) {
        moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Session expired. Please login again');
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedData['data'],
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> curHeaders = {
        'Content-Type': 'application/json',
        'token': SharedPreferenceController.accessToken.toString(),
      };
      printRequest(uri.toString(), body, curHeaders);
      debugPrint('Calling URL: $uri');
      final Response response = await post(
        uri,
        headers: curHeaders,
        body: jsonEncode(body),
      );

      printResponse(uri.toString(), response);

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else if (response.statusCode == 401) {
        moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: 'Session expired. Please login again');
      } else {
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: decodedData['data']);
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void printRequest(
      String uri, Map<String, dynamic>? body, Map<String, dynamic>? headers) {
    debugPrint(
        'Called URL: $uri\nRequest Body: ${body}\nRequest Headers: ${headers}');
  }

  static void printResponse(String uri, Response response) {
    debugPrint(
        'Called URL: $uri\nResponse Code: ${response.statusCode}\nResponse Body: ${response.body}');
  }

  static void moveToLogin() async {
    await SharedPreferenceController.clearAllData();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (value) => false);
  }
}
