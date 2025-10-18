import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/routers/app_router.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/tab/homes_page/home_vm/home_cubit.dart';
import 'package:meko_project/widget/app_dialog/app_dialog.dart';

import 'domains/dependency_injection/service_locator.dart';
import 'main_cubit/main_cubit.dart';
import 'main_cubit/main_state.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return  MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (_) => MainCubit()),
        BlocProvider<HomeCubit>.value(value: getIt<HomeCubit>()),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Meko Project',
            color: Colors.transparent,
            locale: state.locale,
            initialRoute: RouterPaths.splash,
            onGenerateRoute: (settings) {
              return AppRouter.instance.onGenerateRoute(settings);
            },
            debugShowCheckedModeBanner: false,
            navigatorKey: appNavigatorKey,
          );
        },
      ),
    );
  }
}