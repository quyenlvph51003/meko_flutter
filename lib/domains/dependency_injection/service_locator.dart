import 'package:get_it/get_it.dart';
import 'package:meko_project/domains/api_path/app_config.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/global_data/data_local/hive_db.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/history/history_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/repository/package/package_repository.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/repository/report/report_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart';
import 'package:meko_project/repository/user/user_repo.dart';
import 'package:meko_project/repository/violation/violation_repo.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    getIt.registerLazySingleton<RestClient>(() {
      return RestClient(AppConfig.instance.baseUrl);
    });
    getIt.registerLazySingleton<AuthRepository>(() {
      return AuthRepository(restClient: getIt<RestClient>(), sharedPref: SharedPref.instance);
    });
    getIt.registerSingleton<CategoryRepository>(CategoryRepository(restClient: getIt<RestClient>()));
    getIt.registerSingleton<PostRepo>(PostRepo(restClient: getIt<RestClient>()));
    getIt.registerSingleton<UserRepo>(UserRepo(restClient: getIt<RestClient>(), sqLiteManager: SQLiteManager.instance()));

    getIt.registerLazySingleton<WardRepo>(() {
      return WardRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<ProvinceRepo>(() {
      return ProvinceRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<FavoriteRepo>(() {
      return FavoriteRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<HistoryRepo>(() {
      return HistoryRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<ReviewRepo>(() {
      return ReviewRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<ReportRepo>(() {
      return ReportRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<ViolationRepo>(() {
      return ViolationRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<PaymentRepo>(() {
      return PaymentRepo(restClient: getIt<RestClient>());
    });
    getIt.registerLazySingleton<PackageRepository>(() {
      return PackageRepository(restClient: getIt<RestClient>());
    });
  }
}
