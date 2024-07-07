import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _isGetProgressTaskListsInProgress = false;
  List<TaskModel> progressTaskLists = [];

  @override
  void initState() {
    super.initState();
    _getProgressTaskLists();
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
                  _getProgressTaskLists();
                },
                child: Visibility(
                  visible: _isGetProgressTaskListsInProgress == false,
                  replacement: const ProgressIndicatorWidget(),
                  child: ListView.builder(
                    itemCount: progressTaskLists.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: progressTaskLists[index],
                        defaultTaskStatus: 'Progress',
                        onUpdateTask: () {
                          _getProgressTaskLists();
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

  Future<void> _getProgressTaskLists() async {
    _isGetProgressTaskListsInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.progressTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      progressTaskLists = taskListWrapperModel.task ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ??
              'Get progress task lists failed! Try again',
          true,
        );
      }
    }

    _isGetProgressTaskListsInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
