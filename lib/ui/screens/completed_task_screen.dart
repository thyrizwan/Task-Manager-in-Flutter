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

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskListInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _getCompletedTaskList,
      child: Visibility(
        visible: !_getCompletedTaskListInProgress,
        replacement: const CenteredCircularProgressIndicator(
            currentSemanticsLabel: 'Loading completed tasks...'),
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            // return Center(child: Text('Task $index'));
            return TaskCard(
              taskModel: _completedTaskList[index],
              onRefreshList: [_getCompletedTaskList],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    _completedTaskList.clear();
    _getCompletedTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: '${Urls.fetchTaskByStatusUrl}/Completed');

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.data ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getCompletedTaskListInProgress = false;
    setState(() {});
  }
}
