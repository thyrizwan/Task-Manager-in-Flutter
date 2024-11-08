import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskListInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _getProgressTaskList,
      child: Visibility(
        visible: !_getProgressTaskListInProgress,
        replacement: const CenteredCircularProgressIndicator(currentSemanticsLabel: 'Loading progress tasks...'),
        child: ListView.separated(
          itemCount: _progressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _progressTaskList[index],
              onRefreshList: [_getProgressTaskList],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _progressTaskList.clear();
    _getProgressTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: '${Urls.fetchTaskByStatusUrl}/Progress');

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _progressTaskList = taskListModel.data ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getProgressTaskListInProgress = false;
    setState(() {});
  }
}
