import 'package:meko_project/consts/prod_config.dart';
import 'package:meko_project/consts/uat_config.dart';

class AppConfig {
  AppConfig._();

  static BaseConfig? _instance;

  static BaseConfig get instance {
    return _instance ??= ConfigProd();
  }

  static void setUat() {
    _instance = ConfigUat();
  }

  static void setProd() {
    _instance = ConfigProd();
  }
}

abstract class BaseConfig {
  String get baseUrl;
}
