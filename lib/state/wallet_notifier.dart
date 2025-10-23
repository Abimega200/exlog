import 'dart:async';

import '../models/transaction.dart';
import '../services/storage_service.dart';

class WalletState {
  final double budget;
  final double totalIncome;
  final double totalExpense;

  const WalletState({
    required this.budget,
    required this.totalIncome,
    required this.totalExpense,
  });

  double get remaining => totalIncome - totalExpense;
}

class WalletNotifier {
  WalletNotifier._();
  static final WalletNotifier instance = WalletNotifier._();

  final _controller = StreamController<WalletState>.broadcast();
  Stream<WalletState> get stream => _controller.stream;

  Future<void> refresh() async {
    final budget = await StorageService.instance.getBudget();
    final txs = await StorageService.instance.getTransactions();
    double income = 0;
    double expense = 0;
    for (final t in txs) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    _controller.add(WalletState(
      budget: budget,
      totalIncome: income,
      totalExpense: expense,
    ));
  }

  Future<void> addEntry(TransactionEntry entry) async {
    await StorageService.instance.addTransaction(entry);
    await refresh();
  }

  Future<void> setBudget(double amount) async {
    await StorageService.instance.setBudget(amount);
    await refresh();
  }

  // Do not dispose the singleton controller from UI layers
}
