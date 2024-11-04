import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _getCancelTaskListInProgress = false;
  List<TaskModel> _cancelTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _getCancelTaskList,
      child: Visibility(
        visible: !_getCancelTaskListInProgress,
        replacement: const CenteredCircularProgressIndicator(currentSemanticsLabel: 'Loading cancel tasks...'),
        child: ListView.separated(
          itemCount: _cancelTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _cancelTaskList[index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getCancelTaskList() async {
    _cancelTaskList.clear();
    _getCancelTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: '${Urls.fetchTaskByStatusUrl}/Cancel');

    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _cancelTaskList = taskListModel.data ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCancelTaskListInProgress = false;
    setState(() {});
  }
}