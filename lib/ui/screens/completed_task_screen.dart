import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/controller/completed_task_controller.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  void _initialCall() {
    Get.find<CompletedTaskController>().getCompletedTaskLists();
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
                child: GetBuilder<CompletedTaskController>(
                  builder: (completedTaskController) {
                    return Visibility(
                      visible: completedTaskController
                              .isGetCompletedTaskListsInProgress ==
                          false,
                      replacement: const ProgressIndicatorWidget(),
                      child: ListView.builder(
                        itemCount: completedTaskController.taskList.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: completedTaskController.taskList[index],
                            defaultTaskStatus: 'Completed',
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
