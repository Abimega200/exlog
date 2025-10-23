import 'dart:async';

import '../models/wallet_transaction.dart';
import '../services/storage_service.dart';

class WalletTotals {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const WalletTotals({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

class WalletNotifier {
  final StorageService _storage;
  final StreamController<WalletTotals> _totalsController =
      StreamController<WalletTotals>.broadcast();

  WalletNotifier(this._storage);

  Stream<WalletTotals> get totalsStream => _totalsController.stream;

  Future<void> refresh() async {
    final items = await _storage.getTransactions();
    double income = 0;
    double expense = 0;
    for (final tx in items) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }
    final balance = income - expense;
    _totalsController.add(
      WalletTotals(
        totalIncome: income,
        totalExpense: expense,
        balance: balance,
      ),
    );
  }

  void dispose() {
    _totalsController.close();
  }
}
