import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/models/task_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
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
  bool _getTaskCountListInProgress = false;
  List<TaskStatusModel> _taskStatusCountList = [];
  final TaskListController _newTaskListController =
      Get.find<TaskListController>();

  @override
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
              child: GetBuilder<TaskListController>(builder: (controller) {
                return Visibility(
                  visible: !controller.inProgress,
                  replacement: const CenteredCircularProgressIndicator(
                      currentSemanticsLabel: 'Loading new tasks'),
                  child: ListView.separated(
                    itemCount: controller.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: controller.taskList[index],
                        onRefreshList: [_getNewTaskList, _getTaskStatusCount],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                  ),
                );
              }),
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
    final bool result = await _newTaskListController.getTaskList(status: 'New');
    if (result == false) {
      showSnackBarMessage(context,
          _newTaskListController.errorMessage ?? 'Unknown error', true);
    }
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
