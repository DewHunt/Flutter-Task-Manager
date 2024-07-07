import 'package:task_manager/data/models/task_status_count_model.dart';

class TaskStatusCountWrapperModel {
  String? status;
  List<TaskStatusCountModel>? taskStatusCount;

  TaskStatusCountWrapperModel({this.status, this.taskStatusCount});

  TaskStatusCountWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCount = <TaskStatusCountModel>[];
      json['data'].forEach((v) {
        taskStatusCount!.add(TaskStatusCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskStatusCount != null) {
      data['data'] = taskStatusCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
