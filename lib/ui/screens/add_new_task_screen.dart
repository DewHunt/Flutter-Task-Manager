import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/profile_app_bar.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final AddNewTaskController addNewTaskController =
    Get.find<AddNewTaskController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: BackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter task subject';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        maxLines: 10,
                        controller: _descriptionTEController,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                      ),
                      const SizedBox(height: 16),
                      GetBuilder<AddNewTaskController>(
                          builder: (addNewTaskController) {
                        return Visibility(
                          visible:
                              addNewTaskController.isAddNewTaskInProgress ==
                                  false,
                          replacement: const ProgressIndicatorWidget(),
                          child: ElevatedButton(
                            onPressed: _addNewTask,
                            child: const Text('Add'),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    if (_formKey.currentState!.validate()) {
      final AddNewTaskController addNewTaskController =
          Get.find<AddNewTaskController>();
      final bool result = await addNewTaskController.addNewTask(
        _titleTEController.text.trim(),
        _descriptionTEController.text.trim(),
        "New",
      );

      if (result) {
        _clearTextFields();
        if (mounted) {
          showSnackBarMessage(context, addNewTaskController.message);
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            addNewTaskController.message,
            true,
          );
        }
      }
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
