import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/progress_task_controller.dart';
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
    _initialCall();
  }

  void _initialCall() {
    Get.find<ProgressTaskController>().getProgressTaskLists();
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
                  _initialCall();
                },
                child: GetBuilder<ProgressTaskController>(
                  builder: (progressTaskController) {
                    return Visibility(
                      visible: progressTaskController.isGetProgressTaskListsInProgress == false,
                      replacement: const ProgressIndicatorWidget(),
                      child: ListView.builder(
                        itemCount: progressTaskController.taskLists.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: progressTaskController.taskLists[index],
                            defaultTaskStatus: 'Progress',
                            onUpdateTask: _initialCall,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
