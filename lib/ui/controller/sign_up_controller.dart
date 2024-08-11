import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class SignUpController extends GetxController {
  bool _isRegistrationInProgress = false;
  String _successMessage = '';
  String _errorMessage = '';

  bool get isRegistrationInProgress => _isRegistrationInProgress;

  String get successMessage => _successMessage;

  String get errorMessage => _errorMessage;

  Future<bool> registration(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;
    _isRegistrationInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": '',
    };

    ApiResponse responseData = await ApiCaller.postRequest(
      Urls.registration,
      body: requestData,
    );

    print(responseData);

    if (responseData.isSuccess) {
      _successMessage = 'Registration success';
      isSuccess = true;
    } else {
      _errorMessage =
          responseData.errorMessage ?? 'Registration flied! try again';
    }

    _isRegistrationInProgress = false;
    update();

    return isSuccess;
  }
}
