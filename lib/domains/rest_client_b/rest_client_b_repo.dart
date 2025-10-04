import 'package:get/get.dart';
import 'package:meko_project/consts/app_config.dart';
import 'package:meko_project/domains/rest_client_b/rest_client_b.dart';

class RestClientBRepo extends GetxService {
  Future<RestClientBRepo> init() async {
    return this;
  }

  static RestClientB restClientB = RestClientB(AppConfig.instance.baseUrl);
}
