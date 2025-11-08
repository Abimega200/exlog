import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Terms of Service',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '1. Acceptance of Terms',
                  content:
                      'By accessing and using the Expense Logger app, you accept and agree to be bound by the terms and provision of this agreement. '
                      'If you do not agree to these terms, please do not use the app.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '2. Use License',
                  content:
                      'Permission is granted to temporarily use the Expense Logger app for personal, non-commercial transitory viewing only. '
                      'This is the grant of a license, not a transfer of title, and under this license you may not:\n\n'
                      '• Modify or copy the materials\n'
                      '• Use the materials for any commercial purpose\n'
                      '• Attempt to reverse engineer any software\n'
                      '• Remove any copyright or proprietary notations',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '3. User Responsibilities',
                  content:
                      'You are responsible for:\n\n'
                      '• Maintaining the confidentiality of your account\n'
                      '• All activities that occur under your account\n'
                      '• Ensuring the accuracy of your transaction data\n'
                      '• Complying with all applicable laws and regulations',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '4. Data Accuracy',
                  content:
                      'While we strive to provide accurate information, we do not warrant that the app will be error-free. '
                      'You are responsible for verifying the accuracy of your financial data. '
                      'We are not liable for any losses resulting from inaccurate data entry.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '5. Limitation of Liability',
                  content:
                      'In no event shall Expense Logger or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) '
                      'arising out of the use or inability to use the app, even if we have been notified of the possibility of such damage.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '6. Modifications',
                  content:
                      'We reserve the right to modify these terms at any time. '
                      'We will notify users of any material changes by updating the "Last updated" date. '
                      'Your continued use of the app after such modifications constitutes acceptance of the updated terms.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '7. Contact Information',
                  content:
                      'If you have any questions about these Terms of Service, please contact us at:\n\n'
                      'Email: support@expenselogger.com\n'
                      'Phone: +1 (234) 567-8900',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}


