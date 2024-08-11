import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';
import 'package:task_manager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List<TaskStatusCountModel> taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _initialCall();
  }

  void _initialCall() {
    Get.find<NewTaskController>().getNewTaskLists();
    Get.find<NewTaskController>().getTaskStatusCountLists();
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
                  _initialCall();
                },
                child: GetBuilder<NewTaskController>(
                  builder: (newTaskController) {
                    return Visibility(
                      visible: newTaskController.isGetNewTaskListsInProgress ==
                          false,
                      replacement: const ProgressIndicatorWidget(),
                      child: ListView.builder(
                        itemCount: newTaskController.taskList.length,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: newTaskController.taskList[index],
                            defaultTaskStatus: 'New',
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
    return GetBuilder<NewTaskController>(
      builder: (newTaskController) {
        return Visibility(
          visible: newTaskController.isGetTaskStatusCountInProgress == false,
          replacement: const SizedBox(
            height: 100,
            child: ProgressIndicatorWidget(),
          ),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: newTaskController.taskStatusCountList.map((element) {
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
    );
  }
}
