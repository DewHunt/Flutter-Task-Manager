import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class EditTaskController extends GetxController {
  bool _isEditTaskInProgress = false;
  String _errorMessage = '';

  bool get isEditTaskInProgress => _isEditTaskInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> editTask(
    String taskId,
    String status,
  ) async {
    bool isSuccess = false;
    _isEditTaskInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.editTask(taskId, status),
    );

    if (responseData.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ?? 'Edit task failed! Try again.';
    }

    _isEditTaskInProgress = false;
    update();

    return isSuccess;
  }
}
