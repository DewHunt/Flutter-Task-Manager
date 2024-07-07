import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';

AppBar profileAppBar(context, [bool isFromUpdateProfileScreen = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: () {
        if (isFromUpdateProfileScreen == false) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen(),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AuthController.userData?.fullName ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          radius: 10,
          child: Image.memory(
            base64Decode(
              AuthController.userData?.photo ?? '',
            ),
          ),
        ),
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await AuthController.clearAllData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (route) => false,
          );
        },
        icon: const Icon(Icons.logout_outlined),
        color: Colors.red,
      )
    ],
  );
}
