import 'package:task_manager/data/models/task_model.dart';

class TaskListWrapperModel {
  String? status;
  List<TaskModel>? task;

  TaskListWrapperModel({this.status, this.task});

  TaskListWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      task = <TaskModel>[];
      json['data'].forEach((v) {
        task!.add(TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (task != null) {
      data['data'] = task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
