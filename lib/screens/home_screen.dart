import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: unused_import
import '../screens/transaction_details_screen.dart';
import '../state/wallet_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _notifier = WalletNotifier.instance;

  @override
  void initState() {
    super.initState();
    _notifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
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
              // Balance Summary Card (dynamic)
              StreamBuilder<WalletState>(
                stream: _notifier.stream,
                builder: (context, snapshot) {
                  final state = snapshot.data ?? const WalletState(
                    budget: 0,
                    totalIncome: 0,
                    totalExpense: 0,
                  );
                  final totalBalance = state.totalIncome - state.totalExpense;
                  return Container(
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
                          '₹${totalBalance.toStringAsFixed(2)}',
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
                                '₹${state.totalIncome.toStringAsFixed(2)}',
                                Icons.trending_up,
                                const Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildBalanceItem(
                                'Expenses',
                                '₹${state.totalExpense.toStringAsFixed(2)}',
                                Icons.trending_down,
                                const Color(0xFFF44336),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
    final transactions = [
      {
        'icon': Icons.work_outline,
        'title': 'Upwork',
        'date': 'Jan 15, 2022',
        'amount': '+ \$850.00',
        'isIncome': true,
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'Paypal',
        'date': 'Jan 14, 2022',
        'amount': '+ \$1,406.00',
        'isIncome': true,
      },
      {
        'icon': Icons.play_circle_outline,
        'title': 'Youtube',
        'date': 'Jan 13, 2022',
        'amount': '- \$11.00',
        'isIncome': false,
      },
    ];

    return transactions.map((transaction) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                isIncome: transaction['isIncome'] as bool,
                amount: transaction['amount'] as String,
                title: transaction['title'] as String,
                fromTo: transaction['isIncome'] as bool
                    ? 'Upwork Escrow'
                    : 'Claire Jkwaki',
                date: DateTime(2022, 2, 28),
                time: transaction['isIncome'] as bool ? '10:00 AM' : '04:00 PM',
                earnings: transaction['isIncome'] as bool ? 870.0 : 85.0,
                fee: transaction['isIncome'] as bool ? 20.0 : 0.0,
                total: transaction['isIncome'] as bool ? 850.0 : 85.0,
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
                child: Icon(
                  transaction['icon'] as IconData,
                  color: const Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction['date'] as String,
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
                    transaction['amount'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: transaction['isIncome'] as bool
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    transaction['isIncome'] as bool
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: transaction['isIncome'] as bool
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

// ignore: non_constant_identifier_names
TransactionDetailsScreen({required bool isIncome, required String amount, required String title, required String fromTo, required DateTime date, required String time, required double earnings, required double fee, required double total}) {
}
