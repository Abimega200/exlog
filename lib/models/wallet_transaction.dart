import 'dart:convert';

enum TransactionType { income, expense }

TransactionType transactionTypeFromString(String value) {
  return value.toLowerCase() == 'income'
      ? TransactionType.income
      : TransactionType.expense;
}

String transactionTypeToString(TransactionType type) {
  return type == TransactionType.income ? 'income' : 'expense';
}

class WalletTransaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final String description;
  final String counterparty; // source/destination
  final DateTime date;

  WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.counterparty,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': transactionTypeToString(type),
        'amount': amount,
        'category': category,
        'description': description,
        'counterparty': counterparty,
        'date': date.toIso8601String(),
      };

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      type: transactionTypeFromString(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      counterparty: json['counterparty'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
    );
  }

  static String encodeList(List<WalletTransaction> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  static List<WalletTransaction> decodeList(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => WalletTransaction.fromJson(e))
          .toList();
    }
    return [];
  }
}
