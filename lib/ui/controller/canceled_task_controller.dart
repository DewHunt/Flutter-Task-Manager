import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class CanceledTaskController extends GetxController {
  bool _isGetCanceledTaskListsInProgress = false;
  List<TaskModel> _taskList = [];
  String _errorMessage = '';

  bool get isGetCanceledTaskListsInProgress =>
      _isGetCanceledTaskListsInProgress;

  List<TaskModel> get taskList => _taskList;

  String get errorMessage => _errorMessage;

  Future<bool> getCanceledTaskList() async {
    bool isSuccess = false;
    _isGetCanceledTaskListsInProgress = true;
    update();

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.canceledTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      _taskList = taskListWrapperModel.task ?? [];
      isSuccess = true;
    } else {
      _errorMessage = responseData.errorMessage ??
          'Get canceled task lists failed! Try again';
    }

    _isGetCanceledTaskListsInProgress = false;
    update();

    return isSuccess;
  }
}
