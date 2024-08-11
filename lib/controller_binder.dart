import 'package:get/get.dart';
import 'package:task_manager/ui/controller/add_new_task_controller.dart';
import 'package:task_manager/ui/controller/canceled_task_controller.dart';
import 'package:task_manager/ui/controller/completed_task_controller.dart';
import 'package:task_manager/ui/controller/delete_task_controller.dart';
import 'package:task_manager/ui/controller/edit_task_controller.dart';
import 'package:task_manager/ui/controller/email_verification_controller.dart';
import 'package:task_manager/ui/controller/new_task_controller.dart';
import 'package:task_manager/ui/controller/pin_verification_controller.dart';
import 'package:task_manager/ui/controller/progress_task_controller.dart';
import 'package:task_manager/ui/controller/reset_password_controller.dart';
import 'package:task_manager/ui/controller/sign_in_controller.dart';
import 'package:task_manager/ui/controller/sign_up_controller.dart';
import 'package:task_manager/ui/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => NewTaskController());
    Get.lazyPut(() => CompletedTaskController());
    Get.lazyPut(() => CanceledTaskController());
    Get.lazyPut(() => ProgressTaskController());
    Get.lazyPut(() => AddNewTaskController());
    Get.lazyPut(() => EditTaskController());
    Get.lazyPut(() => DeleteTaskController());
    Get.lazyPut(() => UpdateProfileController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => EmailVerificationController());
    Get.lazyPut(() => PinVerificationController());
    Get.lazyPut(() => ResetPasswordController());
  }
}
