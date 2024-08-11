import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controller_binder.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/utilities/app_colors.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManager.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: _buildLightThemeData(),
      initialBinding: ControllerBinder(),
    );
  }

  ThemeData _buildLightThemeData() {
    return ThemeData(
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: AppColors.themeColor,
            foregroundColor: AppColors.white,
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600
          )
        ),
      ),
    );
  }
}
