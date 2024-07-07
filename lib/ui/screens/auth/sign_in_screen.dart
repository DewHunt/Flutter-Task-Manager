import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/sign_in_wrapper_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
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
  bool _isSignInProgress = false;

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
                      Visibility(
                        visible: _isSignInProgress == false,
                        replacement: const ProgressIndicatorWidget(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signIn();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
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

  Future<void> _signIn() async {
    _isSignInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.login, body: requestData);

    _isSignInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (responseData.isSuccess) {
      SignInWrapperModel signIn = SignInWrapperModel.fromJson(responseData.responseData);
      await AuthController.saveUserAccessToken(signIn.token!);
      await AuthController.saveUserData(signIn.user!);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavScreen(),
          ),
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ??
              'Email or password is not correct. Try again',
          true,
        );
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
