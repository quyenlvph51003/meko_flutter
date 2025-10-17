import 'package:flutter/material.dart';
import 'package:meko_project/screens/login_page/login_page.dart';
import 'package:meko_project/screens/splash_page/splash_page.dart';
import 'package:meko_project/screens/tab/homes_page/home_page.dart';

import 'app_router_paths.dart';

class AppRouter {
  AppRouter._();

  static AppRouter? _instance;

  static AppRouter get instance {
    return _instance ??= AppRouter._();
  }

  MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) {
        return router(context: context, routeName: settings.name!, data: settings.arguments);
      },
    );
  }

  Widget router({required BuildContext context, required String routeName, Object? data}) {
    switch (routeName) {
      case RouterPaths.splash:
        return SplashPage();
      case RouterPaths.login:
        return LoginPage(onSuccess: () {}, onTapRegister: () {  },);
      case RouterPaths.homePage:
        return HomePage();
      default:
        return SizedBox();
    }
  }
}
