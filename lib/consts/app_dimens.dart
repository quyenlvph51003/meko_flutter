import 'package:flutter/material.dart';

class AppDimens {
  static const double appBarHeight = 56;

  static double getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget kHeightBottom(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: SizedBox(
        height: MediaQuery.of(context).padding.bottom > 0 ? 0 : 12,
      ),
    );
  }
}
