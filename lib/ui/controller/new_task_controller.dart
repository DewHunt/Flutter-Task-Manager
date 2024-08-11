import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_count_wrapper_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';

class NewTaskController extends GetxController {
  bool _isGetNewTaskListsInProgress = false;
  bool _isGetTaskStatusCountInProgress = false;
  List<TaskModel> _taskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];
  String _newTaskErrorMessage = '';
  String _taskStatusErrorMessage = '';

  bool get isGetNewTaskListsInProgress => _isGetNewTaskListsInProgress;

  bool get isGetTaskStatusCountInProgress => _isGetTaskStatusCountInProgress;

  List<TaskModel> get taskList => _taskList;

  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;

  String get newTaskErrorMessage => _newTaskErrorMessage;

  String get taskStatusErrorMessage => _taskStatusErrorMessage;

  Future<bool> getNewTaskLists() async {
    bool isSuccess = false;
    _isGetNewTaskListsInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(Urls.newTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      _taskList = taskListWrapperModel.task ?? [];
      isSuccess = true;
    } else {
      _newTaskErrorMessage =
          responseData.errorMessage ?? 'Get new task lists failed! Try again';
    }

    _isGetNewTaskListsInProgress = false;
    update();

    return isSuccess;
  }

  Future<bool> getTaskStatusCountLists() async {
    bool isSuccess = false;
    _isGetTaskStatusCountInProgress = true;
    update();

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.taskStatusCount,
    );

    if (responseData.isSuccess) {
      TaskStatusCountWrapperModel taskStatusCountWrapperModel =
          TaskStatusCountWrapperModel.fromJson(responseData.responseData);
      _taskStatusCountList = taskStatusCountWrapperModel.taskStatusCount ?? [];
      isSuccess = true;
    } else {
      _taskStatusErrorMessage = responseData.errorMessage ??
          'Get task status count failed! Try again.';
    }

    _isGetTaskStatusCountInProgress = false;
    update();

    return isSuccess;
  }
}
