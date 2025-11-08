import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  TransactionType type;

  @HiveField(2)
  String category;

  @HiveField(3)
  double amount;

  @HiveField(4)
  double fee;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  String? counterparty; // From/To

  @HiveField(7)
  DateTime dateTime;

  TransactionModel({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.fee = 0,
    this.notes,
    this.counterparty,
    required this.dateTime,
  });
}
