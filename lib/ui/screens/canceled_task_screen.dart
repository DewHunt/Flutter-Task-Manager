import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _isGetCanceledTaskListsInProgress = false;
  List<TaskModel> canceledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCanceledTaskList();
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
                  _getCanceledTaskList();
                },
                child: Visibility(
                  visible: _isGetCanceledTaskListsInProgress == false,
                  replacement: const ProgressIndicatorWidget(),
                  child: ListView.builder(
                    itemCount: canceledTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: canceledTaskList[index],
                        defaultTaskStatus: 'Canceled',
                        onUpdateTask: () {
                          _getCanceledTaskList();
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

  Future<void> _getCanceledTaskList() async {
    _isGetCanceledTaskListsInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData =
        await ApiCaller.getRequest(Urls.canceledTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      canceledTaskList = taskListWrapperModel.task ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ??
              'Get canceled task lists failed! Try again',
          true,
        );
      }
    }

    _isGetCanceledTaskListsInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
