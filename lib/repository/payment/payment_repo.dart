import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/models/response_common.dart';
import 'package:meko_project/repository/user/user_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class PaymentRepo {
  final RestClient restClient;

  PaymentRepo({required this.restClient});

  Future<dynamic> createPayment({required double amount, required int userId}) async {
    try {
      final response = await restClient.post(ApiPath.payment, data: {'amount': amount, 'userId': userId});
      if (response.statusCode == 200 && response.data != null) {
        final result = response.data['data'];
        return result;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<ResponseCommon<List<UserPaymentModel>>?> getUserPayments() async {
    try {
      final user=await SqliteHelper.getUserSql();
      if(user==null) return null;
      final response = await restClient.get('${ApiPath.userPayment}',queryParameters: {'userId':user?.id});
      return ResponseCommon<List<UserPaymentModel>>.fromJson(
        response.data,
        (obj) => (obj as List).map((e) => UserPaymentModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<UserPaymentModel>>(datetime: '', errorCode: 500, message: e.toString(), data: null, content: const [], success: false);
    }
  }


  //user mua gói
  Future<bool> purchasePackage({ required int packageId, required double amount, required String pinWallet})async{
    try{
      final user=await SqliteHelper.getUserSql();
      if(user==null) return false;
      final response=await restClient.post(ApiPath.paymentPurchase,data: {
        'userId': user.id,
        'packageId': packageId,
        'amount': amount,
        'pinWallet':pinWallet
      });

      final result=ResponseCommon<UserPaymentModel>.fromJson(
        response.data,
        (obj)  => UserPaymentModel.fromJson(obj));
      if(result.isSuccess){
        getIt<UserRepo>().getUserProfile(); // ghi đè lại
        return true;
      }
      return false;
    }catch(error){
      print(error);
      return false;
    }
  }
}
