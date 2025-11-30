import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/transaction/transaction_model.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<Transaction>? transactions;
  bool isLoading = true;

  Future<void> _fetchWalletHistory() async {
    try {
      final client = getIt<RestClient>();
      final user = await SqliteHelper.getUserSql();
      if (user == null) return;

      final response = await client.get(ApiPath.getWalletHistory, queryParameters: {'userId': user.id});
      final list = response.data['data'];

      setState(() {
        transactions = list.map<Transaction>((e) => Transaction.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching wallet history: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWalletHistory();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.cMain,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Lịch sử nạp tiền', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: AppLoader())
          : (transactions == null || transactions!.isEmpty)
          ? _buildEmptyView()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions!.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final tx = transactions![index];
                return ListTile(
                  leading: CircleAvatar(child: Text(tx.amount >= 0 ? '+' : '-'), backgroundColor: tx.amount >= 0 ? AppColor.cMain : Colors.red),
                  title: Text(currencyFormat.format(tx.amount)),
                  subtitle: Text(
                    'Số dư hiện tại: ${currencyFormat.format(tx.currentWalletBalance)}\n'
                    'Ngày: ${DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt)}',
                  ),
                  isThreeLine: true,
                );
              },
            ),
    );
  }

  /// Widget hiển thị khi danh sách trống
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          const Text("Không có giao dịch nào", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
