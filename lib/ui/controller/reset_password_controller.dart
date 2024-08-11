import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class ResetPasswordController extends GetxController {
  bool _isSetPasswordInProgress = false;
  String _successMessage = '';
  String _errorMessage = '';

  bool get isSetPasswordInProgress => _isSetPasswordInProgress;
  String get successMessage => _successMessage;
  String get errorMessage => _errorMessage;

  Future<bool> setPassword(String password) async {
    bool isSuccess = false;
    String? verifiedEmail = await AuthController.getVerifiedEmail();
    String? verifiedOtp = await AuthController.getVerifiedOtp();
    _isSetPasswordInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      'email': verifiedEmail,
      'OTP': verifiedOtp,
      'password': password,
    };

    ApiResponse responseData =
    await ApiCaller.postRequest(Urls.recoverResetPass, body: requestData);

    if (responseData.isSuccess) {
      AuthController.clearAllData();
      _successMessage = 'Your new password set successfully';
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ?? 'Set password failed! Try again.';
    }

    _isSetPasswordInProgress = false;
    update();

    return isSuccess;
  }
}
