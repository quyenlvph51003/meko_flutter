import 'package:flutter/material.dart';
import 'package:meko_project/main_app.dart';

import 'domains/dependency_injection/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  runApp(MainApp());
}
