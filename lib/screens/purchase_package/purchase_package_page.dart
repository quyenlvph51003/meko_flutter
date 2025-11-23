import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';

class PurchasePackagePage extends StatefulWidget {
  final int? packageId;
  final String? price; // string from PackageModel
  final String? title;
  const PurchasePackagePage({super.key, this.packageId, this.price,this.title});

  @override
  State<PurchasePackagePage> createState() => _PurchasePackagePageState();
}

class _PurchasePackagePageState extends State<PurchasePackagePage> {
  String _pin = '';
  String _walletBalance = '0';
  bool _submitting = false;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final user = await SqliteHelper.getUserSql();
    setState(() {
      _walletBalance = user?.walletBalance ?? '0';
    });
  }

  void _onPay() async {
    if (_pin.length != 6) return;
    setState(() => _submitting = true);
    // TODO: call payment API / confirm purchase with packageId and pin
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _submitting = false);
    // For now just return success
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final priceNum = double.tryParse(widget.price ?? '0') ?? 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mua gói')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.title}', style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 22)),
            const SizedBox(height: 4),
            Text('Số dư ví', style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(FormatUtils.formatCurrency(double.tryParse(_walletBalance) ?? 0), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 24),
            Text('Số tiền cần thanh toán', style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(FormatUtils.formatCurrency(priceNum), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 24),
            const Text('Nhập mã PIN 6 số'),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _pin = v.trim()),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '******'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButtonCommon(
                  text: 'Thanh toán',
                  isLoading: isLoading,
                  backgroundColor: AppColor.cMain,
                  enabled: true,
                  textColor: Colors.white,
                  borderRadius: 20,
                  onPressed: ()async{
                    if(double.tryParse(_walletBalance)! < priceNum){
                       Fluttertoast.showToast(
                        msg: 'Số dư ví của bạn không đủ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                    }else{
                      setState(() {
                        isLoading=true;
                      });
                      final result=await getIt<PaymentRepo>().purchasePackage(packageId: widget.packageId??0, amount: double.tryParse(widget.price??'0')??0, pinWallet: _pin);
                      setState(() {
                        isLoading=false;
                      });
                      if(result){
                        Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: 'Mua gói thành công',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: AppColor.cMain,
                            textColor: Colors.white,
                            fontSize: 16,
                        );
                      }
                      
                    }
                  },
                )
              
            ),
            // const SizedBox(height: 8),
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(false),
            //   child: const Text('Hủy'),
            // ),
          ],
        ),
      ),
    );
  }
}
