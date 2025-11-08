import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/transaction_repository.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repo = TransactionRepository();
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  void load() {
    _transactions = _repo.getAll();
    _repo.listenable().addListener(_onBoxChanged);
  }

  void _onBoxChanged() {
    _transactions = _repo.getAll();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _repo.add(tx);
  }

  Future<void> deleteTransaction(String id) async {
    await _repo.delete(id);
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await _repo.update(tx);
  }

  TransactionModel? getById(String id) => _repo.getById(id);

  String generateId() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(999999);
    return '$millis-$rand';
  }
}

