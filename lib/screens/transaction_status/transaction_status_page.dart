import 'package:flutter/material.dart';

class TransactionStatusPage extends StatelessWidget {
  final bool success;
  final String? message;

  const TransactionStatusPage({super.key, required this.success, this.message});

  @override
  Widget build(BuildContext context) {
    final icon = success ? Icons.check_circle_outline : Icons.error_outline;
    final title = success ? 'Thanh toán thành công' : 'Thanh toán thất bại';
    final color = success ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả giao dịch'),
        centerTitle: true,
        backgroundColor: color,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 96, color: color),
                const SizedBox(height: 24),
                Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 12),
                if (message != null) ...[
                  Text(message!, textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Pop and return to previous screen(s). Caller can refresh profile
                    // after this pop if needed.
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  child: Text(success ? 'Quay về' : 'Thử lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
