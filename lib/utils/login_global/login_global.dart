import 'package:flutter/material.dart';
import 'package:meko_project/screens/login_page/login_page.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_page.dart';

Future<bool> showAuthBottomSheet(
  BuildContext context, {
  required Widget loginPage,
  required Widget registerPage,
}) async {
  try {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SafeArea(
            top: false,
            child: Container(
              child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildScrollableFill(
                      Builder(
                        builder: (innerCtx) {
                          return LoginPage(
                            onSuccess: () {},
                            onTapRegister: () {
                              DefaultTabController.of(innerCtx).animateTo(1);
                              return;
                            },
                          );
                        },
                      ),
                    ),
                    buildScrollableFill(
                      Builder(
                        builder: (innerCtx) {
                          return SignUpPage(
                            onSuccess: () {
                              DefaultTabController.of(innerCtx).animateTo(0);
                              return;
                            },
                            onBackToLogin: () {
                              DefaultTabController.of(innerCtx).animateTo(0);
                              return;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return result ?? false;
  } catch (e) {
    print(e);
    return false;
  }
}

Widget buildScrollableFill(Widget child) {
  return LayoutBuilder(
    builder: (ctx, c) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: c.maxHeight),
        child: IntrinsicHeight(child: child),
      ),
    ),
  );
}
