import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controller/sign_in_controller.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/utilities/app_constants.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    Get.find<SignInController>();
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
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
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
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GetBuilder<SignInController>(
                        builder: (signInController) {
                          return Visibility(
                            visible: signInController.isSignInProgress == false,
                            replacement: const ProgressIndicatorWidget(),
                            child: ElevatedButton(
                              onPressed: _onTapSignInButton,
                              child:
                                  const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 36),
                      _buildGotoSignUpScreen(),
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

  Widget _buildGotoSignUpScreen() {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: _onTapForgotPasswordButton,
            child: const Text(
              'Forgot Password?',
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: const TextStyle(
                    color: AppColors.themeColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _onTapSignUpButton,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapSignInButton() async {
    if (_formKey.currentState!.validate()) {
      final SignInController signInController = Get.find<SignInController>();
      final bool result = await signInController.signIn(
        _emailTEController.text.trim(),
        _passwordTEController.text,
      );

      if (result) {
        Get.offAll(() => const MainBottomNavScreen());
      } else {
        if (mounted) {
          showSnackBarMessage(context, signInController.errorMessage);
        }
      }
    }
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
