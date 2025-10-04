import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/routers/app_router_paths.dart';

class IntroPageVm extends GetxController {
  PageController pageCtrl = PageController();
  final ValueNotifier<int> index = ValueNotifier<int>(0);

  void backTap() {
    if (index.value > 0) {
      index.value = index.value - 1;
      pageCtrl.animateToPage(
        index.value,
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      );
    }
  }

  void nextTap() {
    if (index.value < 2) {
      index.value = index.value + 1;
      pageCtrl.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      );
    } else {
      SharedPref.instance.setBool(AppConsts.keyIntro, true);
      Get.toNamed(RouterPaths.login);
    }
  }

  String getTitleBtn(int i) {
    if (i == 0) {
      return 'Start';
    } else if (i == 1) {
      return 'Next';
    } else {
      return 'Finish';
    }
  }
}
