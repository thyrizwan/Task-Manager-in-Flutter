import 'package:get/get.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/user_info_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/shared_preference_controller.dart';

class AuthController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;

  /// This method is added to sign in the user
  /// @param email: email of the user
  /// @param password: password of the user
  /// @return Future<bool> returns true if the user is signed in successfully, otherwise false
  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await SharedPreferenceController.saveAccessToken(loginModel.token!);
      await SharedPreferenceController.saveUserData(loginModel.data!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }

  /// This method is added to sign up the user
  /// @param signUpRequestBody: SignUpRequestBody object
  /// SignUpRequestBody contains email, password, firstName, lastName, mobile
  /// @return Future<bool> returns true if the user is signed up successfully, otherwise false
  Future<bool> signUp({required SignUpRequestBody signUpRequestBody}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'email': signUpRequestBody.email,
      'password': signUpRequestBody.password,
      'firstName': signUpRequestBody.firstName,
      'lastName': signUpRequestBody.lastName,
      'mobile': signUpRequestBody.mobile,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }

  /// This method is added to validate the email and send the OTP
  /// @param email: email entered by the user
  /// @return Future<bool> returns true if the email is validated successfully, otherwise false
  Future<bool> forgotPassword(String email) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.checkUserEmailExistUrl(email: email),
    );

    if (response.isSuccess) {
      SharedPreferenceController.saveResetEmail(email);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }

  /// This method is added to validate the OTP
  /// @param otp: OTP entered by the user
  /// @return Future<bool> returns true if the OTP is validated successfully, otherwise false
  Future<bool> validateOtp(String otp) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    String tempEmail = SharedPreferenceController.resetEmail.toString();

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.validateOtpUrl(email: tempEmail, otp: int.parse(otp)));

    if (response.isSuccess) {
      SharedPreferenceController.saveOtp(otp);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }

  /// This method is added to reset the password
  /// @param password: new password entered by the user
  /// @return Future<bool> returns true if the password is reset successfully, otherwise false
  Future<bool> resetPassword(String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      'email': SharedPreferenceController.resetEmail.toString(),
      'OTP': SharedPreferenceController.otp.toString(),
      'password': password,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.resetPasswordUrl, body: requestBody);

    if (response.isSuccess) {
      SharedPreferenceController.clearAllData();
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();

    return isSuccess;
  }
}
