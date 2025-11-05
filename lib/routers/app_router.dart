import 'package:flutter/material.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/screens/forgot_pass_page/forgot_pass_page.dart';
import 'package:meko_project/screens/forgot_pass_page/request_otp_page.dart';
import 'package:meko_project/screens/login_page/login_page.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_page.dart';
import 'package:meko_project/screens/splash_page/splash_page.dart';
import 'package:meko_project/screens/tab/homes_page/home_page.dart';

import '../screens/post_detail_page/post_detail_page.dart';
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
    final Map<String, dynamic>? map = (data is Map<String, dynamic>) ? data : null;
    switch (routeName) {
      case AppRouterPaths.splash:
        return SplashPage();
      case AppRouterPaths.login:
        return LoginPage(onSuccess: () {}, onTapRegister: () {}, showBack: map?['showBack'] ?? true);
      case AppRouterPaths.homePage:
        return HomePage();
      case AppRouterPaths.requestOtpPage:
        return RequestOtpPage();
      case AppRouterPaths.forgotPassPage:
        return ForgotPassPage();
      case AppRouterPaths.postDetailPage:
        final ListingItem item = map?['item'] as ListingItem;
        final Future<ListingItem> Function(int) loader = map?['loader'] as Future<ListingItem> Function(int);
        return PostDetailPage(item: item, loadDetail: loader);
      case AppRouterPaths.signUpPage:
        return SignUpPage(
          onSuccess: () {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true, arguments: {'showBack': false});
          },
          onBackToLogin: () {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
          },
        );
      default:
        return SizedBox();
    }
  }
}
