import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVerifyOtpInProgress = false;
  String _verifyOtpMessage = '';

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
                        'Pin Verification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'A 6 digit verification pin has been send to your email address',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildPinCodeTextField(),
                      const SizedBox(height: 5),
                      Visibility(
                        visible: _isVerifyOtpInProgress == false,
                        replacement: const ProgressIndicatorWidget(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _verifyOtp();
                            }
                          },
                          child: const Text('Verify'),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _verifyOtpMessage,
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

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: AppColors.themeColor,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter your OTP';
        }
        return null;
      },
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

  Future<void> _verifyOtp() async {
    String? verifiedEmail = await AuthController.getVerifiedEmail();
    _isVerifyOtpInProgress = true;
    if (mounted) {
      setState(() {});
    }

    ApiResponse responseData = await ApiCaller.getRequest(
      Urls.recoverVerifyOTP(
        verifiedEmail!,
        _pinTEController.text.trim(),
      ),
    );

    if (responseData.isSuccess) {
      if (responseData.responseData['status'] == 'success') {
        AuthController.saveVerifyOtp(_pinTEController.text.trim());
        _pinTEController.clear();
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        }
      } else {
        _verifyOtpMessage = 'Invalid OTP code! Try again.';
        if (mounted) {
          showSnackBarMessage(
            context,
            _verifyOtpMessage,
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

    _isVerifyOtpInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}
