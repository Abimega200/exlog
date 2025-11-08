import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I add a new transaction?',
        'answer':
            'Tap the + icon on the home screen to add a new income or expense transaction. Fill in the details including category, amount, and date.',
      },
      {
        'question': 'How do I set budget limits for categories?',
        'answer':
            'Budget limits are pre-set for each expense category. When you try to add an expense that exceeds the limit, you\'ll receive a notification.',
      },
      {
        'question': 'Can I edit or delete a transaction?',
        'answer':
            'Currently, you can view transaction details by tapping on any transaction. Edit and delete features are coming soon.',
      },
      {
        'question': 'How do I download a receipt?',
        'answer':
            'Open any transaction from the list, then tap the "Download Receipt" button to generate a PDF receipt.',
      },
      {
        'question': 'What categories are available?',
        'answer':
            'Expense categories: Food & Dining, Transportation, Shopping, Entertainment, Bills & Utilities, Healthcare, Education, Other. Income categories: Salary, Freelance, Investment.',
      },
      {
        'question': 'How do I view my transaction history?',
        'answer':
            'Tap "See All" on the home screen or navigate to the History screen from the menu to view all your transactions.',
      },
      {
        'question': 'Can I change my profile information?',
        'answer':
            'Yes, go to Profile screen and tap "Profile Info" to edit your name and email. Changes will be reflected immediately.',
      },
      {
        'question': 'How do I export my data?',
        'answer':
            'You can download individual transaction receipts as PDFs. Bulk export feature is coming soon.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'FAQs',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return _FAQItem(
              question: faq['question']!,
              answer: faq['answer']!,
            );
          },
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        title: Text(
          widget.question,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.answer,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

