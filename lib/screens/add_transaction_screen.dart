import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/transaction.dart';
import '../state/wallet_notifier.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // 0 = Income, 1 = Expense
  int _selectedType = 1;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = const [
    'Salary',
    'Freelance',
    'Investments',
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Other',
  ];
  String _selectedCategory = 'Food & Dining';

  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeSelector(),
                const SizedBox(height: 20),
                _buildAmountField(),
                const SizedBox(height: 20),
                _buildCategoryField(),
                const SizedBox(height: 20),
                _buildDescriptionField(),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
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
          _buildTypeTab(label: 'Income', index: 0),
          _buildTypeTab(label: 'Expense', index: 1),
        ],
      ),
    );
  }

  Widget _buildTypeTab({required String label, required int index}) {
    final bool isSelected = _selectedType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedType = index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Amount',
        prefixText: '₹ ',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an amount';
        }
        final parsed = double.tryParse(value.trim());
        if (parsed == null || parsed <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (value) => setState(() => _selectedCategory = value ?? _selectedCategory),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _onSave,
        child: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                'Save',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final amount = double.parse(_amountController.text.trim());
      final entry = TransactionEntry(
        isIncome: _selectedType == 0,
        amount: amount,
        category: _selectedCategory,
        notes: _descriptionController.text.trim(),
        date: DateTime.now(),
      );

      await WalletNotifier.instance.addEntry(entry);
      // Explicit refresh per requirement
      await WalletNotifier.instance.refresh();

      if (mounted) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
