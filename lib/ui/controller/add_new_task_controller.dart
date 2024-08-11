import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class AddNewTaskController extends GetxController {
  bool _isAddNewTaskInProgress = false;
  String _message = '';

  bool get isAddNewTaskInProgress => _isAddNewTaskInProgress;

  String get message => _message;

  Future<bool> addNewTask(
    String title,
    String description,
    String status,
  ) async {
    bool isSuccess = false;
    _isAddNewTaskInProgress = true;
    update();

    Map<String, dynamic> requestData = {
      "title": title,
      "description": description,
      "status": status,
    };

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.createTask, body: requestData);

    _isAddNewTaskInProgress = false;
    update();

    if (responseData.isSuccess) {
      _message = 'New task added';
      isSuccess = true;
    } else {
      _message = responseData.errorMessage ?? 'Add new task failed! Try again';
    }

    return isSuccess;
  }
}
