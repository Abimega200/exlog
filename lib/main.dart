import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/wallet_screen.dart';
import 'screens/history_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/transaction_details_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/help_support_screen.dart';
import 'models/transaction.dart';
import 'state/transaction_provider.dart';
import 'state/profile_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open the transactions box
  await Hive.openBox<TransactionModel>('transactionsBox');

  // Initialize notifications
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()..load()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const ExpenseLoggerApp(),
    ),
  );
}

class ExpenseLoggerApp extends StatelessWidget {
  const ExpenseLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Logger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196F3),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2196F3)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/main': (context) => const MainDashboard(),
        // Transaction routes
        '/wallet': (context) => const WalletScreen(),
        '/history': (context) => const HistoryScreen(),
        '/add': (context) => const AddExpenseScreen(),
        '/faq': (context) => const FAQScreen(),
        '/help': (context) => const HelpSupportScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == TransactionDetailsScreen.routeName) {
          final txId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => TransactionDetailsScreen(transactionId: txId),
          );
        }
        return null;
      },
    );
  }
}
