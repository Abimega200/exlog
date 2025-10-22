import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'transaction_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const HomeScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Calculate balances based on provided transactions
    final double totalIncome = transactions
        .where((t) => (t['isIncome'] as bool? ?? false))
        .fold<double>(0.0, (sum, t) => sum + ((t['amount'] as num?)?.toDouble() ?? 0.0));

    final double totalExpenses = transactions
        .where((t) => !(t['isIncome'] as bool? ?? false))
        .fold<double>(0.0, (sum, t) => sum + ((t['amount'] as num?)?.toDouble() ?? 0.0));

    final double totalBalance = totalIncome - totalExpenses;

    String _fmtCurrency(double value) => value.toStringAsFixed(2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good afternoon,',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      Text(
                        'Enjelin Morgeana',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Balance Summary Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_fmtCurrency(totalBalance)}',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBalanceItem(
                            'Income',
                            '+ \$${_fmtCurrency(totalIncome)}',
                            Icons.trending_up,
                            const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildBalanceItem(
                            'Expenses',
                            '- \$${_fmtCurrency(totalExpenses)}',
                            Icons.trending_down,
                            const Color(0xFFF44336),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Transactions History Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions History',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Transactions List
              ..._buildTransactionList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionList(BuildContext context) {
    final List<Map<String, dynamic>> sorted = List<Map<String, dynamic>>.from(transactions);
    sorted.sort((a, b) {
      final aDate = (a['date'] is DateTime)
          ? (a['date'] as DateTime)
          : DateTime.tryParse(a['date']?.toString() ?? '') ?? DateTime(1970);
      final bDate = (b['date'] is DateTime)
          ? (b['date'] as DateTime)
          : DateTime.tryParse(b['date']?.toString() ?? '') ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    return sorted.map((transaction) {
      final bool isIncome = transaction['isIncome'] as bool? ?? false;
      final double amount = ((transaction['amount'] as num?)?.toDouble() ?? 0.0);
      final String amountStr = '${isIncome ? '+' : '-'} \$${amount.toStringAsFixed(2)}';
      final DateTime date = (transaction['date'] is DateTime)
          ? (transaction['date'] as DateTime)
          : DateTime.tryParse(transaction['date']?.toString() ?? '') ?? DateTime.now();
      final IconData icon = (transaction['icon'] is IconData)
          ? transaction['icon'] as IconData
          : Icons.account_balance_wallet_outlined;

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                isIncome: isIncome,
                amount: amountStr,
                title: transaction['title'] as String? ?? 'Transaction',
                fromTo: transaction['notes'] as String? ?? (isIncome ? 'Incoming' : 'Outgoing'),
                date: date,
                time: DateFormat('hh:mm a').format(date),
                earnings: isIncome ? amount : 0.0,
                fee: 0.0,
                total: amount,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF2196F3), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['title'] as String? ?? 'Transaction',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountStr,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isIncome
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    isIncome
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: isIncome
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
