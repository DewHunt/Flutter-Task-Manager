import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/email_verification_controller.dart';
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
  String _verifyEmailMessage = '';

  @override
  void initState() {
    super.initState();
    Get.find<EmailVerificationController>();
  }

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
                      GetBuilder<EmailVerificationController>(
                        builder: (emailVerificationController) {
                          return Visibility(
                            visible: emailVerificationController
                                    .isVerifyEmailInProgress ==
                                false,
                            replacement: const ProgressIndicatorWidget(),
                            child: ElevatedButton(
                              onPressed: _verifyEmail,
                              child:
                                  const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        },
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
    if (_formKey.currentState!.validate()) {
      EmailVerificationController emailVerificationController =
          Get.find<EmailVerificationController>();
      bool result = await emailVerificationController
          .verifyEmail(_emailTEController.text.trim());

      if (result) {
        if (emailVerificationController.isVerifiedEmail) {
          _emailTEController.clear();
          Get.offAll(() => const PinVerificationScreen());
        } else {
          _verifyEmailMessage = emailVerificationController.errorMessage;
          if (mounted) {
            showSnackBarMessage(
              context,
              _verifyEmailMessage,
              true,
            );
            setState(() {});
          }
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            emailVerificationController.errorMessage,
            true,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
