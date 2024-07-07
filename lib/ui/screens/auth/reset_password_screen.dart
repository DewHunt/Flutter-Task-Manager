import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSetPasswordInProgress = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Password',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Minimum length of password should be 8 character with Letter and number combination',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordTEController,
                        obscureText: _showPassword == false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showPassword = !_showPassword;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your new password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordTEController,
                        obscureText: _showConfirmPassword == false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showConfirmPassword = !_showConfirmPassword;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter your new password again.';
                          }
                          if (value != _passwordTEController.text) {
                            return 'Password not matched! Try again';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _isSetPasswordInProgress == false,
                        replacement: const ProgressIndicatorWidget(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _setPassword();
                            }
                          },
                          child: const Text('Confirm'),
                        ),
                      ),
                      const SizedBox(height: 36),
                      _buildBackToSignInScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInScreen() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Have an account? ",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: 'Sign In',
              style: const TextStyle(
                color: AppColors.themeColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _setPassword() async {
    String? verifiedEmail = await AuthController.getVerifiedEmail();
    String? verifiedOtp = await AuthController.getVerifiedOtp();
    _isSetPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      'email': verifiedEmail,
      'OTP': verifiedOtp,
      'password': _passwordTEController.text,
    };

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.recoverResetPass, body: requestData);

    if (responseData.isSuccess) {
      AuthController.clearAllData();
      _clearTextFields();
      if (mounted) {
        showSnackBarMessage(
          context,
          'Your new password set successfully',
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Set password failed! Try again.',
          true,
        );
      }
    }

    _isSetPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _clearTextFields() {
    _passwordTEController.clear();
    _confirmPasswordTEController.clear();
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    super.dispose();
  }
}
