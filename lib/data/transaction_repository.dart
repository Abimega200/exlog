import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const String boxName = 'transactionsBox';

  Box<TransactionModel> get _box => Hive.box<TransactionModel>(boxName);

  ValueListenable<Box<TransactionModel>> listenable() => _box.listenable();

  List<TransactionModel> getAll() {
    final items = _box.values.toList();
    items.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return items;
  }

  Future<void> add(TransactionModel tx) async {
    await _box.put(tx.id, tx);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> update(TransactionModel tx) async {
    await _box.put(tx.id, tx);
  }

  TransactionModel? getById(String id) => _box.get(id);
}

