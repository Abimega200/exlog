import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../state/transaction_provider.dart';
import '../utils/format.dart';
import '../services/notification_service.dart';

/// Custom top banner widget that slides down from the top
class _BudgetExceededBanner extends StatefulWidget {
  final VoidCallback onDismiss;

  const _BudgetExceededBanner({required this.onDismiss});

  @override
  State<_BudgetExceededBanner> createState() => _BudgetExceededBannerState();
}

class _BudgetExceededBannerState extends State<_BudgetExceededBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start animation
    _controller.forward();

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _controller.status == AnimationStatus.completed) {
        _controller.reverse().then((_) {
          if (mounted) {
            widget.onDismiss();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFDC3545), // Red background
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '⚠️ Budget limit exceeded for this category!',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _controller.reverse().then((_) {
                          widget.onDismiss();
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _type = TransactionType.expense;
  String _selectedCategory = 'Food & Dining';
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _feeCtrl = TextEditingController(text: '0');
  final TextEditingController _counterpartyCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  DateTime _dateTime = DateTime.now();

  final List<String> _categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Salary',
    'Freelance',
    'Investment',
    'Other',
  ];

  // Fixed budget limits for each category
  final Map<String, double> _budgetLimits = {
    'Food & Dining': 5000.0,
    'Transportation': 2000.0,
    'Shopping': 4000.0,
    'Entertainment': 3000.0,
    'Bills & Utilities': 2500.0,
    'Healthcare': 1500.0,
    'Education': 3500.0,
    'Salary': 0.0, // No limit for income categories
    'Freelance': 0.0,
    'Investment': 0.0,
    'Other': 2000.0,
  };

  @override
  void dispose() {
    _amountCtrl.dispose();
    _feeCtrl.dispose();
    _counterpartyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null || !mounted) return;
    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _showBudgetExceededBanner() {
    if (!mounted) return;

    // Create overlay entry for the top banner
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _BudgetExceededBanner(
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<TransactionProvider>();
    final id = provider.generateId();
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    final fee = double.tryParse(_feeCtrl.text.trim()) ?? 0;

    bool budgetExceeded = false;

    // Check budget limit for expenses only
    if (_type == TransactionType.expense) {
      final limit = _budgetLimits[_selectedCategory] ?? 0.0;
      if (limit > 0) {
        // Calculate total spent for this category
        final categoryTransactions = provider.transactions
            .where(
              (tx) =>
                  tx.type == TransactionType.expense &&
                  tx.category == _selectedCategory,
            )
            .toList();
        final totalSpent = categoryTransactions.fold<double>(
          0.0,
          (sum, tx) => sum + tx.amount,
        );
        final newTotal = totalSpent + amount;

        if (newTotal > limit) {
          budgetExceeded = true;
          
          // Show local notification
          await NotificationService.showBudgetExceededNotification(
            _selectedCategory,
            limit,
            newTotal,
          );

          // Show top banner notification
          if (mounted) {
            _showBudgetExceededBanner();
          }
        }
      }
    }

    // Save transaction regardless of budget limit
    final tx = TransactionModel(
      id: id,
      type: _type,
      category: _selectedCategory,
      amount: amount,
      fee: fee,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      counterparty: _counterpartyCtrl.text.trim().isEmpty
          ? null
          : _counterpartyCtrl.text.trim(),
      dateTime: _dateTime,
    );

    await provider.addTransaction(tx);
    if (mounted) {
      // Only show success message if budget wasn't exceeded
      // (to avoid showing both messages at once)
      if (!budgetExceeded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_type == TransactionType.income ? 'Income' : 'Expense'} added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          'Add Transaction',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_downward_rounded),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_upward_rounded),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    helperText:
                        _type == TransactionType.expense &&
                            _budgetLimits[_selectedCategory]! > 0
                        ? 'Budget limit: ${formatCurrency(_budgetLimits[_selectedCategory]!)}'
                        : null,
                    helperMaxLines: 2,
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (val) => setState(
                    () => _selectedCategory = val ?? _categories.first,
                  ),
                  validator: (v) => v == null ? 'Select category' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (v) {
                    final d = double.tryParse(v?.trim() ?? '');
                    if (d == null || d <= 0) return 'Enter valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _feeCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Fee (optional)',
                    hintText: '0',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _counterpartyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'From/To (optional)',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date & Time'),
                  subtitle: Text(
                    DateFormat('EEE, dd MMM yyyy • hh:mm a').format(_dateTime),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDateTime,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
