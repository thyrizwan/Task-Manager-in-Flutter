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
  static const String profileUpdateUrl = '$_baseUrl/profileUpdate';
  static String checkUserEmailExistUrl({required String email}) =>
      '$_baseUrl/RecoverVerifyEmail/$email';
  static String validateOtpUrl({required String email, required int otp}) =>
      '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPassword';
}
