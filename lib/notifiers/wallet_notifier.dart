import 'package:flutter/foundation.dart';

import '../models/wallet_transaction.dart';
import '../services/storage_service.dart';

class WalletNotifier extends ChangeNotifier {
  final StorageService _storage;

  WalletNotifier(this._storage);

  List<WalletTransaction> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;

  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _totalIncome - _totalExpense;

  Future<void> refresh() async {
    _transactions = await _storage.getTransactions();
    _recalculateTotals();
    notifyListeners();
  }

  Future<void> addTransaction(WalletTransaction tx) async {
    await _storage.addTransaction(tx);
    await refresh();
  }

  Future<void> clearAll() async {
    await _storage.clearAll();
    await refresh();
  }

  void _recalculateTotals() {
    double income = 0;
    double expense = 0;
    for (final tx in _transactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    _totalIncome = income;
    _totalExpense = expense;
  }
}
