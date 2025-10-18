import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meko_project/main_app.dart';
import 'package:meko_project/screens/tab/homes_page/home_vm/home_cubit.dart';

import 'domains/dependency_injection/service_locator.dart';
final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  setupDI();
  runApp(MainApp());
}

void setupDI() {
  if (!getIt.isRegistered<HomeCubit>()) {
    getIt.registerLazySingleton<HomeCubit>(() => HomeCubit()..isCheckLogin());
  }
}
