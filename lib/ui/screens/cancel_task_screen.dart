import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  final TaskListController _cancelledTaskListController =
      Get.find<TaskListController>();

  @override
  void initState() {
    super.initState();
    _getCancelTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _getCancelTaskList,
      child: GetBuilder(
          init: _cancelledTaskListController,
          builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CenteredCircularProgressIndicator(
                  currentSemanticsLabel: 'Loading cancel tasks...'),
              child: ListView.separated(
                itemCount: controller.taskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: controller.taskList[index],
                    onRefreshList: [_getCancelTaskList],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              ),
            );
          }),
    );
  }

  Future<void> _getCancelTaskList() async {
    final bool result =
        await _cancelledTaskListController.getTaskList(status: 'Cancel');
    if (result == false) {
      showSnackBarMessage(context,
          _cancelledTaskListController.errorMessage ?? 'Error Occurs', false);
    }
  }
}
