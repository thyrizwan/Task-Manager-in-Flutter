import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_manager_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  XFile? _selectedImage;

  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _emailTEController.text = AuthController.userData?.email ?? '';
    _mobileNumberTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(isProfileScreenOpened: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Profile',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildPhotoPicker(),
              const SizedBox(height: 8),
              _buildUpdateInfoForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _selectProfilePicture,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.camera_alt),
            ),
            const SizedBox(width: 8),
            Text(_getSelectedPictureTitle()),
          ],
        ),
      ),
    );
  }

  String _getSelectedPictureTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return 'Select Profile Picture';
  }

  Widget _buildUpdateInfoForm() {
    return Visibility(
      visible: !_updateProfileInProgress,
      replacement: CenteredCircularProgressIndicator(
          currentSemanticsLabel: 'Updating Profile'),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter first name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'First Name',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _lastNameTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter last name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Last Name',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              enabled: false,
              controller: _emailTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _mobileNumberTEController,
              validator: (String? value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter mobile number';
                }
                if (value!.length < 10) {
                  return 'Mobile number must be at least 10 digits';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Mobile Number',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordTEController,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onTapUpdateInfoButton,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.update),
                  SizedBox(width: 8),
                  Text('Update Information'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapUpdateInfoButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _updateProfile();
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      'firstName': _firstNameTEController.text.trim(),
      'lastName': _lastNameTEController.text.trim(),
      'email': _emailTEController.text.trim(),
      'mobile': _mobileNumberTEController.text,
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      requestBody['photo'] = base64Image;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.profileUpdateUrl,
      body: requestBody,
    );

    _updateProfileInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMessage(context, 'Profile updated successfully');
    } else {
      showSnackBarMessage(
          context, 'Error Occurs: ${response.errorMessage}', true);
    }
  }

  Future<void> _selectProfilePicture() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }
}
