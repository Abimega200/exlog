import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../utils/format.dart';
import '../screens/transaction_details_screen.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final arrow = isIncome
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(arrow, color: color),
      ),
      title: Text(tx.category, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${isIncome ? 'Income' : 'Expense'} • ${formatDateTime(tx.dateTime)}',
      ),
      trailing: Text(
        (isIncome ? '+' : '-') + formatCurrency(tx.amount),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          TransactionDetailsScreen.routeName,
          arguments: tx.id,
        );
      },
    );
  }
}
