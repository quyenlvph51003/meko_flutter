import 'package:get_it/get_it.dart';
import 'package:meko_project/domains/api_path/app_config.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/repository/auth_repository/auth_repo.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    getIt.registerLazySingleton<RestClient>(() {
      return RestClient(AppConfig.instance.baseUrl);
    });

    getIt.registerLazySingleton<AuthRepository>(() {
      return AuthRepository(restClient: getIt<RestClient>());
    });
  }
}
