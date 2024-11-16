import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final TaskListController _completedTaskListController =
      Get.find<TaskListController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _getCompletedTaskList,
      child: GetBuilder(
          init: _completedTaskListController,
          builder: (controller) {
            return Visibility(
              visible: !controller.inProgress,
              replacement: const CenteredCircularProgressIndicator(
                  currentSemanticsLabel: 'Loading completed tasks...'),
              child: ListView.separated(
                itemCount: controller.taskList.length,
                itemBuilder: (context, index) {
                  // return Center(child: Text('Task $index'));
                  return TaskCard(
                    taskModel: controller.taskList[index],
                    onRefreshList: [_getCompletedTaskList],
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

  Future<void> _getCompletedTaskList() async {
    final bool result =
        await _completedTaskListController.getTaskList(status: 'Completed');
    if (result == false) {
      showSnackBarMessage(
          context,
          _completedTaskListController.errorMessage ??
              'Failed to load completed tasks',
          true);
    }
  }
}
