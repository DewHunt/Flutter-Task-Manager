import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class ProgressTaskController extends GetxController {
  bool _isGetProgressTaskListsInProgress = false;
  List<TaskModel> _taskLists = [];
  String _errorMessage = '';

  bool get isGetProgressTaskListsInProgress =>
      _isGetProgressTaskListsInProgress;

  List<TaskModel> get taskLists => _taskLists;

  String get errorMessage => _errorMessage;

  Future<bool> getProgressTaskLists() async {
    bool isSuccess = false;
    _isGetProgressTaskListsInProgress = true;
    update();

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.progressTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      _taskLists = taskListWrapperModel.task ?? [];
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ??
          'Get progress task lists failed! Try again';
    }

    _isGetProgressTaskListsInProgress = false;
    update();

    return isSuccess;
  }
}
