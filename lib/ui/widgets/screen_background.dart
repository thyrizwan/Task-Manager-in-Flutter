import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/utils/assets_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        SvgPicture.asset(
          AssetsPath.backgroundSvg,
          width: screenSize.width,
          height: screenSize.height,
          fit: BoxFit.cover,
        ),
        SafeArea(child: child),
      ],
    );
  }
}