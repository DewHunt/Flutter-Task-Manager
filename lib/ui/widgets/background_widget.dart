import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/utilities/assets_paths.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsPaths.backgroundSvg,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),
        child
      ],
    );
  }
}
