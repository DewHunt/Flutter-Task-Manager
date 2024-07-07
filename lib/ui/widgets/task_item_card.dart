import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.defaultTaskStatus,
    required this.onUpdateTask,
  });

  final String defaultTaskStatus;
  final TaskModel task;
  final VoidCallback onUpdateTask;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  bool _isDeleteTaskInProgress = false;
  bool _isEditTaskInProgress = false;
  String selectedStatus = '';
  List<String> statusList = ['New', 'Completed', 'Canceled', 'Progress'];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.task.status!;
  }

  @override
  Widget build(BuildContext context) {
    String chipBackgroundColor = '0xFF2962FF';

    if (widget.defaultTaskStatus == 'New') {
      chipBackgroundColor = '0xFF2962FF';
    }

    if (widget.defaultTaskStatus == 'Completed') {
      chipBackgroundColor = '0xFF00C853';
    }

    if (widget.defaultTaskStatus == 'Canceled') {
      chipBackgroundColor = '0xFFD50000';
    }

    if (widget.defaultTaskStatus == 'Progress') {
      chipBackgroundColor = '0xFF00BFA5';
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(
          widget.task.title ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.description ?? '',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'Date: ${widget.task.createdDate}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? widget.defaultTaskStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: Color(
                      int.parse(chipBackgroundColor),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 2,
                  ),
                  backgroundColor: Color(
                    int.parse(chipBackgroundColor),
                  ),
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: _isEditTaskInProgress == false,
                      replacement: const ProgressIndicatorWidget(),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.edit_document),
                        constraints: const BoxConstraints.expand(
                          width: 135,
                          height: 240,
                        ),
                        onSelected: (String selectedItem) {
                          selectedStatus = selectedItem;
                          if (mounted) {
                            setState(() {});
                          }
                          _editTask();
                        },
                        itemBuilder: (BuildContext context) {
                          return statusList.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: ListTile(
                                title: Text(choice),
                                trailing: selectedStatus == choice
                                    ? const Icon(Icons.done)
                                    : null,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    Visibility(
                      visible: _isDeleteTaskInProgress == false,
                      replacement: const ProgressIndicatorWidget(),
                      child: IconButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    _isDeleteTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.deleteTask(widget.task.sId!),
    );

    if (responseData.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Delete task failed! Try again.',
        );
      }
    }

    _isDeleteTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _editTask() async {
    _isEditTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.editTask(widget.task.sId!, selectedStatus),
    );

    if (responseData.isSuccess) {
      widget.onUpdateTask();
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Edit task failed! Try again.',
        );
      }
    }

    _isEditTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
