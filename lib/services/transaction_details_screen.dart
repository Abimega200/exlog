
import 'dart:convert';

class TransactionEntry {
  final bool isIncome;
  final double amount;
  final String category;
  final String notes;
  final DateTime date;

  TransactionEntry({
    required this.isIncome,
    required this.amount,
    required this.category,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'isIncome': isIncome,
        'amount': amount,
        'category': category,
        'notes': notes,
        'date': date.toIso8601String(),
      };

  static TransactionEntry fromJson(Map<String, dynamic> json) => TransactionEntry(
        isIncome: json['isIncome'] as bool,
        amount: (json['amount'] as num).toDouble(),
        category: json['category'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
        date: DateTime.parse(json['date'] as String),
      );

  static String encodeList(List<TransactionEntry> entries) => jsonEncode(
        entries.map((e) => e.toJson()).toList(),
      );

  static List<TransactionEntry> decodeList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((e) => TransactionEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}