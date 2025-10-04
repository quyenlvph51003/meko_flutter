import 'package:get/get.dart';
import 'package:meko_project/consts/app_config.dart';
import 'package:meko_project/domains/rest_client_a/rest_client_a.dart';

class RestClientARepo extends GetxService {
  Future<RestClientARepo> init() async {
    return this;
  }

  RestClientA restClientA = RestClientA(AppConfig.instance.baseUrl);

  void getabc() {
    restClientA.dio.get('path');
  }
}
