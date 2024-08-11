import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class EmailVerificationController extends GetxController {
  bool _isVerifyEmailInProgress = false;
  bool _isVerifiedEmail = false;
  String _errorMessage = '';

  bool get isVerifyEmailInProgress => _isVerifyEmailInProgress;

  bool get isVerifiedEmail => _isVerifiedEmail;

  String get errorMessage => _errorMessage;

  Future<bool> verifyEmail(String email) async {
    bool isSuccess = false;
    _isVerifyEmailInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.recoverVerifyEmail(email),
    );

    if (responseData.isSuccess) {
      if (responseData.responseData['status'] == 'success') {
        AuthController.saveVerifiedEmail(email);
        _isVerifiedEmail = true;
      } else {
        _errorMessage = 'No user found! Try again.';
      }
      isSuccess = true;
    } else {
      _errorMessage =
          responseData.errorMessage ?? 'Verify email failed! Try again.';
    }

    _isVerifyEmailInProgress = false;
    update();

    return isSuccess;
  }
}
