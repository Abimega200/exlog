import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../state/wallet_notifier.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final WalletNotifier _notifier = WalletNotifier.instance;
  final TextEditingController _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notifier.refresh();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<WalletState>(
            stream: _notifier.stream,
            builder: (context, snapshot) {
              final state = snapshot.data ?? const WalletState(
                budget: 0,
                totalIncome: 0,
                totalExpense: 0,
              );

              final remaining = state.remaining;
              final exceeded = state.totalExpense > state.budget && state.budget > 0;

              if (exceeded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('⚠️ Budget limit exceeded!'),
                      content: Text(
                        'Your expenses (₹${state.totalExpense.toStringAsFixed(2)}) exceeded the budget (₹${state.budget.toStringAsFixed(2)}).',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                });
              }

              _budgetController.text = state.budget == 0
                  ? ''
                  : state.budget.toStringAsFixed(0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(
                    title: 'Fixed Budget',
                    value: '₹${state.budget.toStringAsFixed(2)}',
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: 'Total Income',
                    value: '₹${state.totalIncome.toStringAsFixed(2)}',
                    color: const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: 'Total Expenses',
                    value: '₹${state.totalExpense.toStringAsFixed(2)}',
                    color: const Color(0xFFF44336),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: 'Remaining Balance',
                    value: '₹${remaining.toStringAsFixed(2)}',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Set Budget',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Enter budget amount (₹)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            final text = _budgetController.text.trim();
                            final value = double.tryParse(text);
                            if (value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid amount'),
                                  backgroundColor: Color(0xFFF44336),
                                ),
                              );
                              return;
                            }
                            await _notifier.setBudget(value);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Budget updated'),
                                backgroundColor: Color(0xFF4CAF50),
                              ),
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF666666),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
