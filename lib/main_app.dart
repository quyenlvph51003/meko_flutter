

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meko_project/routers/app_router.dart';
import 'package:meko_project/routers/app_router_paths.dart';

import 'generated/l10n.dart';
import 'main_vm.dart';

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  MainAppVm vm = Get.put<MainAppVm>(MainAppVm());

  @override
  void initState() {
    super.initState();
    vm.onInit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      color: Colors.transparent,
      initialRoute: RouterPaths.splash,
      onGenerateRoute: (setting) {
        return AppRouter.instance.onGenerateRoute(setting);
      },
      // localizationsDelegates: [
      //   S.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('vi', 'VN'),
      // ],
      debugShowCheckedModeBanner: false,
    );
  }
}
