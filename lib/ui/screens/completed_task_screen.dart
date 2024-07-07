import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _isGetCompletedTaskListsInProgress = false;
  List<TaskModel> completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getCompletedTaskLists();
                },
                child: Visibility(
                  visible: _isGetCompletedTaskListsInProgress == false,
                  replacement: const ProgressIndicatorWidget(),
                  child: ListView.builder(
                    itemCount: completedTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: completedTaskList[index],
                        defaultTaskStatus: 'Completed',
                        onUpdateTask: () {
                          _getCompletedTaskLists();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskLists() async {
    _isGetCompletedTaskListsInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.completedTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      completedTaskList = taskListWrapperModel.task ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ??
              'Get completed task lists failed! Try again',
          true,
        );
      }
    }

    _isGetCompletedTaskListsInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
