import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordOtpVerifyScreen extends StatefulWidget {
  const ForgotPasswordOtpVerifyScreen({super.key});

  @override
  State<ForgotPasswordOtpVerifyScreen> createState() =>
      _ForgotPasswordOtpVerifyScreenState();
}

class _ForgotPasswordOtpVerifyScreenState
    extends State<ForgotPasswordOtpVerifyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpTEController = TextEditingController();
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
                  'Verify Your OTP',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('A reset OTP has been sent to your email address'),
                const SizedBox(height: 24),
                _buildForgotPasswordOtpVerifyForm(),
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
        (_) => false);
  }

  Widget _buildForgotPasswordOtpVerifyForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PinCodeTextField(
            length: 6,
            obscureText: false,
            controller: _otpTEController,
            validator: (String? value) {
              if (value!.isEmpty ?? true) {
                return 'Please enter OTP';
              }
              return null;
            },
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.grey.shade200,
              selectedFillColor: Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            appContext: context,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onTapVerifyOtpButton,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check),
                SizedBox(width: 8),
                Text('Verify OTP'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onTapVerifyOtpButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _verifyOtp();
  }

  Future<void> _verifyOtp() async {
    _inProgress = true;
    setState(() {});

    String tempOtp = _otpTEController.text.trim();
    String tempEmail = AuthController.resetEmail.toString();

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.validateOtpUrl(email: tempEmail, otp: int.parse(tempOtp)));

    if (response.isSuccess) {
      AuthController.saveOtp(tempOtp);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        ),
      );
      showSnackBarMessage(context, 'OTP verified successfully');
    } else {
      showSnackBarMessage(context, 'Error: ${response.errorMessage}', true);
    }

    _inProgress = false;
    setState(() {});
  }
}
