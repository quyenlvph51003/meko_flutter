import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'domains/rest_client_a/rest_client_a_repo.dart';
import 'domains/rest_client_b/rest_client_b_repo.dart';
import 'generated/l10n.dart';
import 'models/enums/enums.dart';

class MainAppVm extends GetxController {
  Locale localLang = Locale('vi', '');

  @override
  void onInit() {
    super.onInit();
    // AppThemes.setAppTheme(ThemeTypes.light, isInit: true);
    // changeLanguage(TypeLanguage.vi, isInit: true);
    initServices();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void initServices() async {
    Get.put(() => RestClientARepo().init());
    Get.put(() => RestClientBRepo().init());
  }

  void changeLanguage(TypeLanguage type, {bool? isInit}) {
    switch (type) {
      case TypeLanguage.vi:
        localLang = Locale('vi', 'Vi');
        break;
      case TypeLanguage.en:
        localLang = Locale('en', 'En');
        break;
    }
    S.load(localLang);
    if (isInit == true) {
      Get.updateLocale(localLang);
    }
  }
}
