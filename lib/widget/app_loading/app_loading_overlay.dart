import 'package:flutter/material.dart';

import 'app_loader.dart';


class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    Key? key,
    required this.visible,
    required this.child,
    this.barrierColor = const Color(0x33000000),
    this.spinnerColor = const Color(0xFF66BB6A),
  }) : super(key: key);

  final bool visible;
  final Widget child;
  final Color barrierColor;
  final Color spinnerColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: ColoredBox(
                color: barrierColor,
                child: Center(
                  child: AppLoader(
                    size: 36,
                    strokeWidth: 3.2,
                    color: spinnerColor,
                    padding: EdgeInsets.zero,
                    height: null,
                    label: null,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}