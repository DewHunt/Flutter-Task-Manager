import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/utilities/app_constants.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVerifyEmailInProgress = false;
  String _verifyEmailMessage = '';

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
                        'Your Email Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'A 6 digit verification pin will send to your email address',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your email';
                          }
                          if (AppConstants.emailRegExp.hasMatch(value!) ==
                              false) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: _isVerifyEmailInProgress == false,
                        replacement: const ProgressIndicatorWidget(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _verifyEmail();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _verifyEmailMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
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
    Navigator.pop(context);
  }

  Future<void> _verifyEmail() async {
    _isVerifyEmailInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.recoverVerifyEmail(
        _emailTEController.text.trim(),
      ),
    );

    if (responseData.isSuccess) {
      if (responseData.responseData['status'] == 'success') {
        AuthController.saveVerifiedEmail(_emailTEController.text.trim());
        _emailTEController.clear();
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PinVerificationScreen(),
            ),
          );
        }
      } else {
        _verifyEmailMessage = 'No user found! Try again.';
        if (mounted) {
          showSnackBarMessage(
            context,
            _verifyEmailMessage,
            true,
          );
        }
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Verify email failed! Try again.',
          true,
        );
      }
    }

    _isVerifyEmailInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
