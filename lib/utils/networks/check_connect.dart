//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectService extends GetxService {
  @override
  void onInit() async {
    super.onInit();
    listenConnect();
  }

  Future<void> listenConnect() async {
    // Connectivity check = Connectivity();
    // ConnectivityResult result = await check.checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //   //  controller.showDialogE('Mất kết nối vui lòng kiểm tra lại!');
    // }
    //
    // check.onConnectivityChanged.listen((event) {
    //   if (event == ConnectivityResult.none) {
    //     print('object');
    //     //     controller.showDialogE('Mất kết nối vui lòng kiểm tra lại!');
    //   }
    // });
  }

  Future<bool> checkConnect() async {
    return true;
    // final connectResult = await Connectivity().checkConnectivity();
    // if (connectResult == ConnectivityResult.mobile) {
    //   return true;
    // } else if (connectResult == ConnectivityResult.wifi) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
