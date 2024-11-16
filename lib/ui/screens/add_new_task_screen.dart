import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_manager_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameTEController = TextEditingController();
  final TextEditingController _taskDescriptionTEController =
      TextEditingController();
  bool _shouldRefreshPreviousScreen = false;
  final TaskListController _taskListController = Get.find<TaskListController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousScreen);
      },
      child: Scaffold(
        appBar: const TaskManagerAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _taskNameTEController,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter task name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Task Name',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: _taskDescriptionTEController,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter task description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(height: 16),
                  GetBuilder(
                    init: _taskListController,
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const CenteredCircularProgressIndicator(
                            currentSemanticsLabel: 'Adding new task'),
                        child: ElevatedButton(
                          onPressed: _onTapAddNewTask,
                          child: const Text('Add New Task'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddNewTask() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    final bool result = await _taskListController.addNewTask(
      title: _taskNameTEController.text.trim(),
      description: _taskDescriptionTEController.text.trim(),
    );

    if (result) {
      _shouldRefreshPreviousScreen = true;
      _clearFields();
      showSnackBarMessage(context, 'New task added successfully');
    } else {
      showSnackBarMessage(
          context, _taskListController.errorMessage ?? 'Error Occurs', true);
    }
  }

  void _clearFields() {
    _taskNameTEController.clear();
    _taskDescriptionTEController.clear();
  }

  @override
  void dispose() {
    _taskNameTEController.dispose();
    _taskDescriptionTEController.dispose();
    super.dispose();
  }
}
