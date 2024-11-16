import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/user_info_model.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/shared_preference_controller.dart';

class UserController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  /// This method is added to get user information
  /// @return Future<UserInfoModel> returns user information
  /// UserInfoModel contains firstName, lastName, email, mobile, photo
  /// @return Future<bool> returns true if the user profile updated successfully, otherwise false
  Future<bool> updateUserInformation({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    String? password,
    String? photo,
  }) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile,
    };

    if (!(password != null && password.isEmpty)) {
    print("The Password is$password,");
      requestBody['password'] = password;
    }
    if (photo != null) {
      requestBody['photo'] = photo;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdateUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(response.responseData);
      await SharedPreferenceController.saveUserData(userModel);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}
