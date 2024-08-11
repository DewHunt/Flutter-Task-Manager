import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class PinVerificationController extends GetxController {
  bool _isVerifyOtpInProgress = false;
  bool _isVerifiedOtp = false;
  String _errorMessage = '';

  bool get isVerifyOtpInProgress => _isVerifyOtpInProgress;

  bool get isVerifiedOtp => _isVerifiedOtp;

  String get errorMessage => _errorMessage;

  Future<bool> verifyOtp(String pin) async {
    bool isSuccess = false;
    String? verifiedEmail = await AuthController.getVerifiedEmail();
    _isVerifyOtpInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.recoverVerifyOTP(verifiedEmail!, pin),
    );

    if (responseData.isSuccess) {
      if (responseData.responseData['status'] == 'success') {
        AuthController.saveVerifyOtp(pin);
        _isVerifiedOtp = true;
      } else {
        _errorMessage = 'Invalid OTP code! Try again.';
      }
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ?? 'Verify email failed! Try again.';
    }

    _isVerifyOtpInProgress = false;
    update();

    return isSuccess;
  }
}
