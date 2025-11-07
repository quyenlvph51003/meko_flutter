class AppConfig {
  static final AppConfig instance = AppConfig._internal();

  factory AppConfig() => instance;

  AppConfig._internal();

  final String baseUrl = 'https://mekobe-production.up.railway.app/api/';
}
