import 'package:flutter/material.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/screens/categories_page/categories_page.dart';
import 'package:meko_project/screens/favorite_page/favorite_page.dart' show FavoritePage;
import 'package:meko_project/screens/forgot_pass_page/forgot_pass_page.dart';
import 'package:meko_project/screens/forgot_pass_page/request_otp_page.dart';
import 'package:meko_project/screens/history_page/history_page.dart';
import 'package:meko_project/screens/login_page/login_page.dart';
import 'package:meko_project/screens/packages_page/packages_page.dart';
import 'package:meko_project/screens/create_post_page/create_post_page.dart';
import 'package:meko_project/screens/purcharse_create_post/purcharse_create_post.dart';
import 'package:meko_project/screens/search_page/search_page.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_page.dart';
import 'package:meko_project/screens/splash_page/splash_page.dart';
import 'package:meko_project/screens/tab/homes_page/home_page.dart';
import 'package:meko_project/screens/top_up_wallet/top_up_wallet.dart';
import 'package:meko_project/screens/update_post_page/update_post_page.dart';
import 'package:meko_project/screens/web_view_page/web_view_page.dart';
import 'package:meko_project/screens/transaction_status/transaction_status_page.dart';
import 'package:meko_project/screens/purchase_package/purchase_package_page.dart';

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
      case AppRouterPaths.categoryPage:
        return CategoriesPage(caytegoryId: map?['caytegoryId'], categoryName: map?['categoryName']);
      case AppRouterPaths.searchPage:
        final Future<List<dynamic>> Function(String) onSearch = map?['onSearch'] as Future<List<dynamic>> Function(String);
        final Widget Function(dynamic) itemBuilder = map?['itemBuilder'] as Widget Function(dynamic);
        final void Function(dynamic) onSelected = map?['onSelected'] as void Function(dynamic);
        String? hintText = map?['hintText'];
        return SearchPage(onSearch: onSearch, itemBuilder: itemBuilder, onSelected: onSelected, hintText: hintText);
      case AppRouterPaths.favoritePage:
        return FavoritePage();
      case AppRouterPaths.historyPage:
        return HistoryPage();
      case AppRouterPaths.updatePostPage:
        return PostUpdateScreen(postId: map?['postId']);
      case AppRouterPaths.createPostPage:
        return PostCreateScreen();
      case AppRouterPaths.topUpPage:
        return TopUpScreen();
      case AppRouterPaths.webviewPage:
        return WebViewScreen(url: map?['url'], title: map?['title'], successUrlContains: map?['successUrlContains'], onSuccess: map?['onSuccess']);
      case AppRouterPaths.transactionStatusPage:
        final bool success = map?['success'] == true;
        final String? message = map?['message'] as String?;
        return TransactionStatusPage(success: success, message: message);
      case AppRouterPaths.purchasePackagePage:
        return PurchasePackagePage(packageId: map?['packageId'] as int?, price: map?['price'] as String?, title: map?['title']);
      case AppRouterPaths.packagePages:
        return PackagesPage();
      case AppRouterPaths.createPost:
        return PostCreateScreen();
      case AppRouterPaths.createPurcharsePost:
        return PurcharseCreatePost();
      default:
        return SizedBox();
    }
  }
}
