import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_verify_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 78),
                Text(
                  'Your Email Address',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('A reset OTP will be sent to your email address'),
                const SizedBox(height: 24),
                _buildForgotPasswordForm(),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      _buildSignInSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'Sign In',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
          ),
        ],
      ),
    );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }

  Widget _buildForgotPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            validator: (String? value) {
              if (value!.isEmpty ?? true) {
                return 'Please enter email';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: !_inProgress,
            replacement: const CenteredCircularProgressIndicator(
                currentSemanticsLabel: 'Sending OTP'),
            child: ElevatedButton(
              onPressed: _onTapSendOtpButton,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded),
                  SizedBox(width: 8),
                  Text('Send OTP'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSendOtpButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _sendOtp();
  }

  Future<void> _sendOtp() async {
    _inProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.checkUserEmailExistUrl(email: _emailTEController.text.trim()),
    );

    _inProgress = false;
    setState(() {});

    if (response.isSuccess) {
      AuthController.saveResetEmail(_emailTEController.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ForgotPasswordOtpVerifyScreen(),
        ),
      );
      showSnackBarMessage(context, 'OTP sent to your email address');
    } else {
      showSnackBarMessage(context, 'Error: ${response.errorMessage}', true);
    }
  }
}
