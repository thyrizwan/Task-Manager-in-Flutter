import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_summary_card.dart';

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
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

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
                Visibility(
                  visible: !_changeStatusInProgress || !_deleteTaskInProgress,
                  replacement: const CenteredCircularProgressIndicator(
                      currentSemanticsLabel: ''),
                  child: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _onTapEditButton,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: _onTapDeleteButton,
                      ),
                    ],
                  ),
                )
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
          title: Text('Edit Status'),
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
              child: Text('Cancel'),
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
    _changeStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(
        taskId: widget.taskModel.sId!,
        status: newStatus,
      ),
    );

    if (response.isSuccess) {
      for (var callback in widget.onRefreshList) {
        callback();
      }
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _changeStatusInProgress = false;
    setState(() {});
  }

  Future<void> _onTapDeleteButton() async {
    _deleteTaskInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(
        taskId: widget.taskModel.sId!,
      ),
    );

    if (response.isSuccess) {
      for (var callback in widget.onRefreshList) {
        callback();
      }
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _deleteTaskInProgress = false;
    setState(() {});
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
