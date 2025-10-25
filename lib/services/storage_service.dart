import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallet_transaction.dart';

class StorageService {
  static const String _kTransactionsKey = 'wallet_transactions';

  Future<List<WalletTransaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kTransactionsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    return WalletTransaction.decodeList(jsonString);
  }

  Future<void> saveTransactions(List<WalletTransaction> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTransactionsKey, WalletTransaction.encodeList(items));
  }

  Future<void> addTransaction(WalletTransaction tx) async {
    final items = await getTransactions();
    items.add(tx);
    await saveTransactions(items);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTransactionsKey);
  }
}
