import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInProgress = false;
  bool _getTaskCountListInProgress = false;
  List<TaskModel> _newTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
          _getTaskStatusCount();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInProgress,
                replacement: const CenteredCircularProgressIndicator(
                    currentSemanticsLabel: 'Loading new tasks'),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                      onRefreshList: [_getNewTaskList, _getTaskStatusCount],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddFloatingActionButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !_getTaskCountListInProgress,
        replacement: const CenteredCircularProgressIndicator(
            currentSemanticsLabel: 'Loading task status count'),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _taskStatusCountList
                .map(
                  (taskStatusModel) => TaskSummaryCard(
                    title: taskStatusModel.sId ?? '',
                    count: taskStatusModel.sum ?? 0,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _onTapAddFloatingActionButton() async {
    final bool? shouldBeRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if (shouldBeRefresh == true) {
      _getNewTaskList();
      _getTaskStatusCount();
    }
  }

  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    _getNewTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: '${Urls.fetchTaskByStatusUrl}/New');

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.data ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getNewTaskListInProgress = false;
    setState(() {});
  }

  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _getTaskCountListInProgress = true;
    setState(() {});

    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.fetchTaskStatusCountUrl);

    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
          TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getTaskCountListInProgress = false;
    setState(() {});
  }
}
