import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_images.dart';

class WidgetHelper {
  static Widget backArrow(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
        child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
      ),
    );
  }

  static Widget noDataListing() {
    return Column(
      children: [
        Image.asset(AppImages.icon_no_data_listing2, width: 100, height: 100),
        const Text('Không có bài viết', style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
