import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'add_expense_screen.dart';
import 'transaction_details_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // Index into _screens (does not include the Wallet item)
  int _currentScreenIndex = 0;

  final List<Map<String, dynamic>> _transactions = <Map<String, dynamic>>[
    {
      'icon': Icons.work_outline,
      'title': 'Upwork',
      'date': DateTime(2022, 1, 15),
      'amount': 850.00,
      'isIncome': true,
      'notes': 'Upwork Escrow',
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'title': 'Paypal',
      'date': DateTime(2022, 1, 14),
      'amount': 1406.00,
      'isIncome': true,
      'notes': 'Transfer',
    },
    {
      'icon': Icons.play_circle_outline,
      'title': 'Youtube',
      'date': DateTime(2022, 1, 13),
      'amount': 11.00,
      'isIncome': false,
      'notes': 'Subscription',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Widget body = _currentScreenIndex == 0
        ? HomeScreen(transactions: _transactions)
        : _currentScreenIndex == 1
            ? const StatisticsScreen()
            : const ProfileScreen();
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Map the selected screen index to nav index, skipping the Wallet item (index 1)
        currentIndex: _currentScreenIndex >= 1
            ? _currentScreenIndex + 1
            : _currentScreenIndex,
        onTap: (index) {
          // If wallet (index 1) tapped, navigate to TransactionDetailsScreen
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailsScreen(
                  isIncome: true,
                  amount: '\$850.00',
                  title: 'Wallet',
                  fromTo: 'Upwork Escrow',
                  date: DateTime(2022, 2, 28),
                  time: '10:00 AM',
                  earnings: 870.0,
                  fee: 20.0,
                  total: 850.0,
                ),
              ),
            );
            return;
          }
          setState(() {
            _currentScreenIndex = index > 1 ? index - 1 : index;
          });
        },
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: const Color(0xFF666666),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          if (result != null) {
            setState(() {
              _transactions.add(result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Transaction added'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
