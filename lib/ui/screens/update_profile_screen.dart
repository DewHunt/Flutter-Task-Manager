import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/api_response.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/network_caller/api_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/utilities/app_constants.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/profile_app_bar.dart';
import 'package:task_manager/ui/widgets/progress_indicator_widget.dart';
import 'package:task_manager/ui/widgets/snack_bar_message_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  bool _showPassword = false;
  bool _isUpdateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData!.email ?? '';
    _firstNameTEController.text = AuthController.userData!.firstName ?? '';
    _lastNameTEController.text = AuthController.userData!.lastName ?? '';
    _mobileTEController.text = AuthController.userData!.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context, true),
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
                        'Update Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildPhotoPicker(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailTEController,
                        enabled: false,
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
                        controller: _firstNameTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'First Name',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _lastNameTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Last Name',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _mobileTEController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Mobile',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your phone number';
                          }
                          if (AppConstants.mobileRegExp.hasMatch(value!) ==
                              false) {
                            return 'Enter valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordTEController,
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
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: _isUpdateProfileInProgress == false,
                        replacement: const ProgressIndicatorWidget(),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateProfile();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
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

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: () {
        _pickProfileImage();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                color: Colors.grey,
              ),
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                _selectedImage?.name ?? 'No image selected',
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final imagePicker = ImagePicker();
    final XFile? result = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (result != null) {
      _selectedImage = result;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _updateProfile() async {
    String encodedPhoto = AuthController.userData?.photo ?? '';
    _isUpdateProfileInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "photo": "",
    };

    if (_passwordTEController.text.isNotEmpty) {
      requestData['password'] = _passwordTEController.text.trim();
    }

    if (_selectedImage != null) {
      File file = File(_selectedImage!.path);
      encodedPhoto = base64Encode(file.readAsBytesSync());
      requestData['photo'] = encodedPhoto;
    }

    ApiResponse responseData =
        await ApiCaller.postRequest(Urls.profileUpdate, body: requestData);

    if (responseData.isSuccess &&
        responseData.responseData['status'] == 'success') {
      UserModel userData = UserModel(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        photo: encodedPhoto,
      );

      await AuthController.saveUserData(userData);

      if (mounted) {
        showSnackBarMessage(
          context,
          'Profile update success',
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          responseData.errorMessage ?? 'Profile update failed! Try again.',
          true,
        );
      }
    }

    _isUpdateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
