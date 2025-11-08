import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
                  'Privacy Policy',
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
                  title: '1. Information We Collect',
                  content:
                      'We collect information that you provide directly to us, including:\n\n'
                      '• Personal information (name, email address)\n'
                      '• Transaction data (income, expenses, categories)\n'
                      '• Device information and usage data\n\n'
                      'All data is stored locally on your device for your privacy and security.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '2. How We Use Your Information',
                  content:
                      'We use the information we collect to:\n\n'
                      '• Provide and improve our services\n'
                      '• Process your transactions\n'
                      '• Send you notifications about budget limits\n'
                      '• Respond to your support requests',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '3. Data Storage',
                  content:
                      'All your financial data is stored locally on your device using secure local storage. '
                      'We do not transmit your personal or financial information to external servers. '
                      'Your data remains private and under your control.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '4. Data Security',
                  content:
                      'We implement appropriate security measures to protect your information. '
                      'However, no method of transmission over the internet or electronic storage is 100% secure. '
                      'While we strive to protect your data, we cannot guarantee absolute security.',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '5. Your Rights',
                  content:
                      'You have the right to:\n\n'
                      '• Access your personal data\n'
                      '• Correct inaccurate data\n'
                      '• Delete your account and data\n'
                      '• Export your transaction data',
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '6. Contact Us',
                  content:
                      'If you have any questions about this Privacy Policy, please contact us at:\n\n'
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


