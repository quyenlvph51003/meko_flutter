import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/screens/intro_page/intro_page.dart';
import 'package:meko_project/screens/login_page/login_page.dart';

class SplashVm extends GetxController {
  final ValueNotifier<bool> flagOpacity = ValueNotifier<bool>(false);

  void init() async {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      bool? check = await SharedPref.instance.getBool(AppConsts.keyIntro);
      if (check == true) {
        Get.off(
          () => LoginPage(),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 150),
        );
      } else {
        Get.off(
          () => IntroPage(),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 150),
        );
      }
    });
  }

  void updateBrg() {
    flagOpacity.value = true;
  }
}
