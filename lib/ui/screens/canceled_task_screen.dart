import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/canceled_task_controller.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  void _initialCall() {
    Get.find<CanceledTaskController>().getCanceledTaskList();
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
                child: GetBuilder<CanceledTaskController>(
                  builder: (canceledTaskController) {
                    return Visibility(
                      visible: canceledTaskController
                              .isGetCanceledTaskListsInProgress ==
                          false,
                      replacement: const ProgressIndicatorWidget(),
                      child: ListView.builder(
                        itemCount: canceledTaskController.taskList.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: canceledTaskController.taskList[index],
                            defaultTaskStatus: 'Canceled',
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
