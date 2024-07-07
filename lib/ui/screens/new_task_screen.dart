import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_count_wrapper_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';
import 'package:task_manager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _isGetNewTaskListsInProgress = false;
  bool _isGetTaskStatusCountInProgress = false;
  List<TaskModel> newTaskList = [];
  List<TaskStatusCountModel> taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskLists();
    _getTaskStatusCountLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _buildTaskSummarySection(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _getNewTaskLists();
                  _getTaskStatusCountLists();
                },
                child: Visibility(
                  visible: _isGetNewTaskListsInProgress == false,
                  replacement: const ProgressIndicatorWidget(),
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: newTaskList[index],
                        defaultTaskStatus: 'New',
                        onUpdateTask: () {
                          _getNewTaskLists();
                          _getTaskStatusCountLists();
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        onPressed: _onTapAddButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTapAddButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
  }

  Widget _buildTaskSummarySection() {
    return Visibility(
      visible: _isGetTaskStatusCountInProgress == false,
      replacement: const SizedBox(
        height: 100,
        child: ProgressIndicatorWidget(),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: taskStatusCountList.map((element) {
              return TaskSummaryCard(
                title: (element.sId ?? 'Unknown').toUpperCase(),
                count: element.sum.toString(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _getNewTaskLists() async {
    _isGetNewTaskListsInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(Urls.newTaskList);

    if (responseData.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
          TaskListWrapperModel.fromJson(responseData.responseData);
      newTaskList = taskListWrapperModel.task ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Get new task lists failed! Try again',
          false,
        );
      }
    }

    _isGetNewTaskListsInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _getTaskStatusCountLists() async {
    _isGetTaskStatusCountInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.taskStatusCount,
    );

    if (responseData.isSuccess) {
      TaskStatusCountWrapperModel taskStatusCountWrapperModel =
          TaskStatusCountWrapperModel.fromJson(responseData.responseData);
      taskStatusCountList = taskStatusCountWrapperModel.taskStatusCount ?? [];
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ??
              'Get task status count failed! Try again.',
        );
      }
    }

    _isGetTaskStatusCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
