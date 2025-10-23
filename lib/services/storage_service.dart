import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class StorageKeys {
  static const String budgetAmount = 'budget_amount';
  static const String transactions = 'transactions_json';
}

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  Future<double> getBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(StorageKeys.budgetAmount) ?? 0.0;
    
  }

  Future<void> setBudget(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(StorageKeys.budgetAmount, amount);
  }

  Future<List<TransactionEntry>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(StorageKeys.transactions);
    if (jsonStr == null || jsonStr.isEmpty) return <TransactionEntry>[];
    try {
      return TransactionEntry.decodeList(jsonStr);
    } catch (_) {
      return <TransactionEntry>[];
    }
  }

  Future<void> addTransaction(TransactionEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getTransactions();
    final updated = [...current, entry];
    await prefs.setString(
      StorageKeys.transactions,
      TransactionEntry.encodeList(updated),
    );
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.transactions);
    await prefs.remove(StorageKeys.budgetAmount);
  }
}
