import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/routers/app_router.dart';
import 'package:meko_project/routers/app_router_paths.dart';

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

    return BlocProvider(
      create: (context) => MainCubit(),
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

            // Uncomment khi cần localization
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
          );
        },
      ),
    );
  }
}