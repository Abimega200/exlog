import 'dart:async';
import '../services/storage_service.dart';
import '../services/transaction_details_screen.dart';

class WalletState {
  final double budget;
  final double totalIncome;
  final double totalExpense;

  const WalletState({
    required this.budget,
    required this.totalIncome,
    required this.totalExpense, required List entries,
  });

  double get remaining => totalIncome - totalExpense;
}

class WalletNotifier {
  WalletNotifier._();
  static final WalletNotifier instance = WalletNotifier._();

  final _controller = StreamController<WalletState>.broadcast();
  Stream<WalletState> get stream => _controller.stream;

  // ✅ Keep a list of all transactions
  List<TransactionEntry> _entries = [];

  List<TransactionEntry> get entries => _entries;

  // ✅ Refresh wallet state from storage
  Future<void> refresh() async {
    final budget = await StorageService.instance.getBudget();
    final txs = await StorageService.instance.getTransactions();

    _entries = txs; // store in memory

    double income = 0;
    double expense = 0;

    for (final t in txs) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    _controller.add(
      WalletState(budget: budget, totalIncome: income, totalExpense: expense, entries: []),
    );
  }

  // ✅ Add a transaction and refresh state
  Future<void> addEntry(TransactionEntry entry) async {
    await StorageService.instance.addTransaction(entry);
    await refresh();
  }

  // ✅ Set new budget
  Future<void> setBudget(double amount) async {
    await StorageService.instance.setBudget(amount);
    await refresh();
  }

  // ✅ Calculate total spent for a specific category
  double totalSpentForCategory(String category) {
    return _entries
        .where((e) => !e.isIncome && e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}
