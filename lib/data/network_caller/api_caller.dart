import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';

class ApiCaller {
  static Future<ApiResponse> getRequest(String url) async {
    try {
      debugPrint(url);
      Response response = await get(
        Uri.parse(url),
        headers: {
          'token': AuthController.accessToken,
        },
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseData,
        );
      } else if (response.statusCode == 401) {
        redirectToSignInScreen();
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (error) {
      return ApiResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: error.toString(),
      );
    }
  }

  static Future<ApiResponse> postRequest(String url,
      {Map<String, dynamic>? body}) async {
    try {
      debugPrint(url);
      debugPrint(body.toString());
      Response response = await post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-type': 'Application/json',
          'token': AuthController.accessToken,
        },
      );
      // debugPrint(AuthController.accessToken);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: responseData,
        );
      } else if (response.statusCode == 401) {
        redirectToSignInScreen();
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (error) {
      return ApiResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: error.toString(),
      );
    }
  }

  static Future<void> redirectToSignInScreen() async {
    await AuthController.clearAllData();
    Navigator.pushAndRemoveUntil(
        TaskManager.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (route) => false);
  }
}
