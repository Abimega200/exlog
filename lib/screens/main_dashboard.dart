import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';
import 'add_transaction_screen.dart';
import 'wallet_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // Index into _screens (does not include the Wallet item)
  int _currentScreenIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Map the selected screen index to nav index, skipping the Wallet item (index 1)
        currentIndex: _currentScreenIndex >= 1
            ? _currentScreenIndex + 1
            : _currentScreenIndex,
        onTap: (index) {
          // If wallet (index 1) tapped, open Wallet screen
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WalletScreen(),
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
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (added == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Transaction added successfully'),
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
