import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/sign_in_wrapper_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class SignInController extends GetxController {
  bool _isSignInProgress = false;
  String _errorMessage = '';

  bool get isSignInProgress => _isSignInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _isSignInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "password": password,
    };

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.login, body: requestData);

    if (responseData.isSuccess) {
      SignInWrapperModel signIn =
          SignInWrapperModel.fromJson(responseData.responseData);
      await AuthController.saveUserAccessToken(signIn.token!);
      await AuthController.saveUserData(signIn.user!);
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ?? 'Login Failed';
    }

    _isSignInProgress = false;
    update();
    return isSuccess;
  }
}
