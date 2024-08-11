import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _isUpdateProfileInProgress = false;
  String _successMessage = '';
  String _errorMessage = '';

  bool get isUpdateProfileInProgress => _isUpdateProfileInProgress;

  String get successMessage => _successMessage;
  String get errorMessage => _errorMessage;

  Future<bool> updateProfile(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String photo,
    String password,
  ) async {
    bool isSuccess = false;
    _isUpdateProfileInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "photo": "",
    };

    if (password.isNotEmpty) {
      requestData["password"] = password;
    }

    if(photo.isNotEmpty){
      requestData["photo"] = photo;
    }

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.profileUpdate, body: requestData);

    if (responseData.isSuccess &&
        responseData.responseData['status'] == 'success') {
      UserModel userData = UserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: photo,
      );

      await AuthController.saveUserData(userData);

      _successMessage = 'Profile update success';
      isSuccess = true;
    } else {
      _errorMessage =
          responseData.errorMessage ?? 'Profile update failed! Try again.';
    }

    _isUpdateProfileInProgress = false;
    update();

    return isSuccess;
  }
}
