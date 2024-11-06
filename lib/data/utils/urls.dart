class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String fetchTaskByStatusUrl = '$_baseUrl/listTaskByStatus';
  static String updateTaskStatusUrl({String taskId = '', String status = ''}) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';
  static String deleteTaskUrl({String taskId = ''}) =>
      '$_baseUrl/deleteTask/$taskId';
  static const String fetchTaskStatusCountUrl = '$_baseUrl/taskStatusCount';
}
