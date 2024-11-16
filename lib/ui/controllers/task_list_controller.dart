import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class TaskListController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<TaskModel> _taskList = [];

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  List<TaskModel> get taskList => _taskList;


  /// This method is added to get the list of tasks with status
  ///
  /// @return Future<bool> returns true if the task list is fetched successfully, otherwise false
  Future<bool> getTaskList({required String status}) async {
    _inProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: '${Urls.fetchTaskByStatusUrl}/$status');

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.data ?? [];
      _isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return _isSuccess;
  }

  // /// This method is added to get the list of tasks with status 'Progress'
  // /// @return Future<bool> returns true if the task list is fetched successfully, otherwise false
  // Future<bool> getInProgressTaskList() async {
  //   _inProgress = true;
  //   update();
  //   final NetworkResponse response = await NetworkCaller.getRequest(
  //       url: '${Urls.fetchTaskByStatusUrl}/Progress');
  //
  //   if (response.isSuccess) {
  //     final TaskListModel taskListModel =
  //         TaskListModel.fromJson(response.responseData);
  //     _taskList = taskListModel.data ?? [];
  //     _isSuccess = true;
  //   } else {
  //     _errorMessage = response.errorMessage;
  //   }
  //
  //   _inProgress = false;
  //   update();
  //
  //   return _isSuccess;
  // }
  //
  // /// This method is added to get the list of tasks with status 'Completed'
  // /// @return Future<bool> returns true if the task list is fetched successfully, otherwise false
  // Future<bool> getCompletedTaskList() async {
  //   _inProgress = true;
  //   update();
  //   final NetworkResponse response = await NetworkCaller.getRequest(
  //       url: '${Urls.fetchTaskByStatusUrl}/Completed');
  //
  //   if (response.isSuccess) {
  //     final TaskListModel taskListModel =
  //         TaskListModel.fromJson(response.responseData);
  //     _taskList = taskListModel.data ?? [];
  //     _isSuccess = true;
  //   } else {
  //     _errorMessage = response.errorMessage;
  //   }
  //
  //   _inProgress = false;
  //   update();
  //
  //   return _isSuccess;
  // }
  //
  // /// This method is added to get the list of tasks with status 'Cancelled'
  // /// @return Future<bool> returns true if the task list is fetched successfully, otherwise false
  // Future<bool> getCancelledTaskList() async {
  //   _inProgress = true;
  //   update();
  //   final NetworkResponse response = await NetworkCaller.getRequest(
  //       url: '${Urls.fetchTaskByStatusUrl}/Cancel');
  //
  //   if (response.isSuccess) {
  //     final TaskListModel taskListModel =
  //         TaskListModel.fromJson(response.responseData);
  //     _taskList = taskListModel.data ?? [];
  //     _isSuccess = true;
  //   } else {
  //     _errorMessage = response.errorMessage;
  //   }
  //
  //   _inProgress = false;
  //   update();
  //
  //   return _isSuccess;
  // }

  /// This method is added to add new task
  /// @param title: the title of the task
  /// @param description: the description of the task
  /// @return Future<bool> returns true if the task is added successfully, otherwise false
  Future<bool> addNewTask({
    required String title,
    required String description,
  }) async {
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      'status': 'New'
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return _isSuccess;
  }

  /// This method is added to update task status
  /// @param taskId: the id of the task
  /// @param status: the status of the task
  /// @return Future<bool> returns true if the task status is updated successfully, otherwise false
  Future<bool> changeTaskStatus(
      {required String taskId, required String status}) async {
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatusUrl(
        taskId: taskId,
        status: status,
      ),
    );

    if (response.isSuccess) {
      _isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return _isSuccess;
  }

  /// This method is added to delete task
  /// @param taskId: the id of the task
  /// @return Future<bool> returns true if the task is deleted successfully, otherwise false
  Future<bool> deleteTask({required String taskId}) async {
    _inProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(
        taskId: taskId,
      ),
    );

    if (response.isSuccess) {
      _isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();

    return _isSuccess;
  }
}
