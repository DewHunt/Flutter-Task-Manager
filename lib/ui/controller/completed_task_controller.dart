import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class CompletedTaskController extends GetxController {
  bool _isGetCompletedTaskListsInProgress = false;
  List<TaskModel> _taskList = [];
  String _errorMessage = '';

  bool get isGetCompletedTaskListsInProgress =>
      _isGetCompletedTaskListsInProgress;

  List<TaskModel> get taskList => _taskList;

  String get errorMessage => _errorMessage;

  Future<bool> getCompletedTaskLists() async {
    bool isSuccess = false;
    _isGetCompletedTaskListsInProgress = true;
    update();

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.completedTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      _taskList = taskListWrapperModel.task ?? [];
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ??
          'Get completed task lists failed! Try again';
    }

    _isGetCompletedTaskListsInProgress = false;
    update();

    return isSuccess;
  }
}
