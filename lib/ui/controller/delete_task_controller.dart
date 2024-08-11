import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class DeleteTaskController extends GetxController {
  bool _isDeleteTaskInProgress = false;
  String _errorMessage = '';

  bool get isDeleteTaskInProgress => _isDeleteTaskInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> deleteTask(String taskId) async {
    bool isSuccess = false;
    _isDeleteTaskInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.deleteTask(taskId),
    );

    if (responseData.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ?? 'Delete task failed! Try again.';
    }

    _isDeleteTaskInProgress = false;
    update();

    return isSuccess;
  }
}
