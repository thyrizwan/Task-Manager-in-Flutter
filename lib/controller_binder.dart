import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/user_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(TaskListController());
    Get.put(UserController());
  }
}
