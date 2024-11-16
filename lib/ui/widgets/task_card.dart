import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onRefreshList,
  });

  final TaskModel taskModel;
  final List<VoidCallback> onRefreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = '';
  late final ColorScheme colors;
  final TaskListController _taskListController = Get.find<TaskListController>();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.taskModel.status ?? '';
    colors = getColorFromString(_selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? 'Not Available',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              widget.taskModel.description ?? 'Not Available',
            ),
            Text(
              widget.taskModel.createdDate ?? 'Not Available',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                GetBuilder(
                    init: _taskListController,
                    builder: (context) {
                      return Visibility(
                        visible: !_taskListController.inProgress,
                        replacement: const CenteredCircularProgressIndicator(
                            currentSemanticsLabel: ''),
                        child: Wrap(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _onTapEditButton,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _onTapDeleteButton,
                            ),
                          ],
                        ),
                      );
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onTapEditButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['New', 'Completed', 'Progress', 'Cancel'].map((e) {
              return ListTile(
                title: Text(e),
                onTap: () {
                  if (_selectedStatus != e) {
                    _updateTaskStatus(e);
                    Navigator.pop(context);
                  }
                  // _updateTaskStatus(e);
                  // Navigator.pop(context);
                },
                selected: _selectedStatus == e,
                selectedColor: colors.textColor,
                // selectedTileColor: colors.bgColor,
                trailing: _selectedStatus == e
                    ? Icon(Icons.check, color: colors.textColor)
                    : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            // TextButton(
            //   onPressed: () {},
            //   child: Text('Okay'),
            // ),
          ],
        );
      },
    );
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        _selectedStatus,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: colors.textColor),
      ),
      backgroundColor: colors.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(color: colors.bgColor),
    );
  }

  Future<void> _updateTaskStatus(String newStatus) async {
    final bool result = await _taskListController.changeTaskStatus(
      taskId: widget.taskModel.sId!,
      status: newStatus,
    );
    if (result) {
      for (var callback in widget.onRefreshList) {
        callback();
      }
    } else {
      showSnackBarMessage(
          context, _taskListController.errorMessage ?? 'Error', true);
    }
  }

  Future<void> _onTapDeleteButton() async {
    final bool result =
        await _taskListController.deleteTask(taskId: widget.taskModel.sId!);
    if (result) {
      for (var callback in widget.onRefreshList) {
        callback();
      }
    } else {
      showSnackBarMessage(
          context, _taskListController.errorMessage ?? 'Error', true);
    }
  }

  ColorScheme getColorFromString(String color) {
    switch (color) {
      case 'New':
        return ColorScheme(
          bgColor: Colors.blue.shade100,
          textColor: Colors.blue.shade900,
        );
      case 'Completed':
        return ColorScheme(
          bgColor: Colors.green.shade100,
          textColor: Colors.green.shade900,
        );
      case 'Progress':
        return ColorScheme(
          bgColor: Colors.yellow.shade100,
          textColor: Colors.yellow.shade900,
        );
      case 'Cancel':
        return ColorScheme(
          bgColor: Colors.red.shade100,
          textColor: Colors.red.shade900,
        );
      default:
        return ColorScheme(
          bgColor: Colors.white,
          textColor: Colors.grey,
        );
    }
  }
}

class ColorScheme {
  final Color bgColor;
  final Color textColor;

  ColorScheme({
    required this.bgColor,
    required this.textColor,
  });
}
