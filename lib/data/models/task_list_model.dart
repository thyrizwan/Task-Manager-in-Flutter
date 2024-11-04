import 'package:task_manager/data/models/task_model.dart';

class TaskListModel {
  String? status;
  List<TaskModel>? data;

  TaskListModel({this.status, this.data});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskModel>[];
      json['data'].forEach((v) {
        data!.add(TaskModel.fromJson(v));
      });
    }
  }
}
