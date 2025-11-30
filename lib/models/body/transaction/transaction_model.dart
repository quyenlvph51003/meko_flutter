class Transaction {
  final int id;
  final int userId;
  final double amount;
  final DateTime createdAt;
  final double currentWalletBalance;

  Transaction({required this.id, required this.userId, required this.amount, required this.createdAt, required this.currentWalletBalance});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      amount: double.parse(json['amount']),
      createdAt: DateTime.parse(json['created_at']),
      currentWalletBalance: double.parse(json['current_wallet_balance']),
    );
  }
}
