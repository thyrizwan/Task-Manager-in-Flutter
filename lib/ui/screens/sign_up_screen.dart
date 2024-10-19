import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                  'Join With Us',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSignUpForm(),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 2),
                      _buildSignUpSection(),
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

  Widget _buildSignUpSection() {
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

  Widget _buildSignUpForm() {
    return Column(
      children: [

        TextFormField(
          decoration: const InputDecoration(
            hintText: 'First Name',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Last Name',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Mobile Number',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType:   TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onTapSignUpButton,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.key_rounded),
              SizedBox(width: 8),
              Text('Sign Up'),
            ],
          ),
        ),
      ],
    );
  }

  void _onTapSignUpButton() {
    // TODO: implement sign in logic
  }
}
