import 'package:flutter/material.dart';
import 'package:meko_project/screens/login_page/login_page.dart';

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
        final goRegister = () => DefaultTabController.of(ctx).animateTo(1);
        return FractionallySizedBox(
          heightFactor: 1,
          child: SafeArea(
            top: false,
            child: Container(
              child: DefaultTabController(
                length: 2,
                child: TabBarView(
                  children: [
                    buildScrollableFill(
                      Builder(builder: (_) {
                        return LoginPage(onSuccess: () {  },
                         onTapRegister: goRegister
                        );
                      }),
                    ),
                    buildScrollableFill(registerPage),
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
