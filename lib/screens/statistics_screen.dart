import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../state/transaction_provider.dart';
import '../models/transaction.dart';
import '../utils/format.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriod = 2; // Month is selected by default
  String _selectedType = 'Expense'; // Expense or Income
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];

  Widget _buildSummaryItem(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF666666),
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  List<TransactionModel> _getFilteredTransactions(
    List<TransactionModel> transactions,
  ) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 0: // Day
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 1: // Week
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 2: // Month
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 3: // Year
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
    }

    return transactions.where((tx) => tx.dateTime.isAfter(startDate)).toList();
  }

  Map<String, double> _generateBarChartData(
    List<TransactionModel> transactions,
  ) {
    if (transactions.isEmpty) return {};

    // Group by day/week/month based on period
    final Map<String, double> grouped = {};
    for (final tx in transactions) {
      String key;
      if (_selectedPeriod == 0) {
        // Day - group by hour
        key = '${tx.dateTime.hour}:00';
      } else if (_selectedPeriod == 1) {
        // Week - group by day name
        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        key = days[tx.dateTime.weekday - 1];
      } else if (_selectedPeriod == 2) {
        // Month - group by day
        key = 'Day ${tx.dateTime.day}';
      } else {
        // Year - group by month name
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        key = months[tx.dateTime.month - 1];
      }

      grouped[key] = (grouped[key] ?? 0) + tx.amount;
    }

    return grouped;
  }

  List<TransactionModel> _getTopTransactions(
    List<TransactionModel> transactions,
    int count,
  ) {
    final sorted = List<TransactionModel>.from(transactions)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return sorted.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final allTransactions = transactionProvider.transactions;

    // Get income and expense transactions separately
    final incomeTransactions = allTransactions
        .where((tx) => tx.type == TransactionType.income)
        .toList();
    final expenseTransactions = allTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .toList();

    final filteredIncome = _getFilteredTransactions(incomeTransactions);
    final filteredExpense = _getFilteredTransactions(expenseTransactions);

    final incomeChartData = _generateBarChartData(filteredIncome);
    final expenseChartData = _generateBarChartData(filteredExpense);

    // Get all unique keys for the chart
    final allKeys = <String>{
      ...incomeChartData.keys,
      ...expenseChartData.keys,
    }.toList();

    // Sort keys based on period type
    if (_selectedPeriod == 0) {
      // Day - sort by hour
      allKeys.sort((a, b) {
        final hourA = int.tryParse(a.split(':')[0]) ?? 0;
        final hourB = int.tryParse(b.split(':')[0]) ?? 0;
        return hourA.compareTo(hourB);
      });
    } else if (_selectedPeriod == 1) {
      // Week - sort by day order
      final dayOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      allKeys.sort((a, b) {
        final indexA = dayOrder.indexOf(a);
        final indexB = dayOrder.indexOf(b);
        return (indexA == -1 ? 999 : indexA).compareTo(
          indexB == -1 ? 999 : indexB,
        );
      });
    } else if (_selectedPeriod == 2) {
      // Month - sort by day number
      allKeys.sort((a, b) {
        final dayA = int.tryParse(a.replaceAll('Day ', '')) ?? 0;
        final dayB = int.tryParse(b.replaceAll('Day ', '')) ?? 0;
        return dayA.compareTo(dayB);
      });
    } else {
      // Year - sort by month order
      final monthOrder = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      allKeys.sort((a, b) {
        final indexA = monthOrder.indexOf(a);
        final indexB = monthOrder.indexOf(b);
        return (indexA == -1 ? 999 : indexA).compareTo(
          indexB == -1 ? 999 : indexB,
        );
      });
    }

    // Create bar groups
    final barGroups = allKeys.asMap().entries.map((entry) {
      final key = entry.value;
      final incomeValue = incomeChartData[key] ?? 0.0;
      final expenseValue = expenseChartData[key] ?? 0.0;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: incomeValue,
            color: const Color(0xFF4CAF50),
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: expenseValue,
            color: const Color(0xFFF44336),
            width: 12,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();

    // Calculate max value for Y axis
    double maxValue = 0;
    for (final key in allKeys) {
      final incomeVal = incomeChartData[key] ?? 0.0;
      final expenseVal = expenseChartData[key] ?? 0.0;
      if (incomeVal > maxValue) maxValue = incomeVal;
      if (expenseVal > maxValue) maxValue = expenseVal;
    }
    if (maxValue == 0) maxValue = 100; // Default max if no data

    // Get filtered transactions for top transactions based on selected type
    final filteredTransactionsForTop = _getFilteredTransactions(
      _selectedType == 'Expense' ? expenseTransactions : incomeTransactions,
    );
    final topTransactions = _getTopTransactions(filteredTransactionsForTop, 5);

    // Calculate totals
    double incomeTotal = 0;
    for (final tx in filteredIncome) {
      incomeTotal += tx.amount;
    }

    double expenseTotal = 0;
    for (final tx in filteredExpense) {
      expenseTotal += tx.amount;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Statistics',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Period Tabs
              Container(
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
                  children: _periods.asMap().entries.map((entry) {
                    int index = entry.key;
                    String period = entry.value;
                    bool isSelected = _selectedPeriod == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPeriod = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2196F3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            period,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              // Combined Income & Expense Overview Chart
              Container(
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2196F3,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.bar_chart,
                            color: Color(0xFF2196F3),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Income & Expense Overview',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: barGroups.isEmpty
                          ? Center(
                              child: Text(
                                'No transaction data',
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxValue * 1.2, // Add 20% padding
                                minY: 0,
                                groupsSpace: 12,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipRoundedRadius: 8,
                                    tooltipPadding: const EdgeInsets.all(8),
                                    tooltipMargin: 8,
                                    tooltipBgColor: Colors.white,
                                    getTooltipItem:
                                        (group, groupIndex, rod, rodIndex) {
                                          final value = rod.toY;
                                          final type = rodIndex == 0
                                              ? 'Income'
                                              : 'Expense';
                                          return BarTooltipItem(
                                            '$type\n${formatCurrency(value)}',
                                            GoogleFonts.inter(
                                              color: rod.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() >= allKeys.length)
                                          // ignore: curly_braces_in_flow_control_structures
                                          return const Text('');
                                        final label = allKeys[value.toInt()];
                                        // Show abbreviated labels for better readability
                                        String displayLabel = label;
                                        if (label.startsWith('Day ')) {
                                          displayLabel = label.replaceAll(
                                            'Day ',
                                            '',
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            displayLabel,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              color: const Color(0xFF666666),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                      reservedSize: 40,
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        if (value == 0) return const Text('');
                                        return Text(
                                          formatCurrency(value),
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            color: const Color(0xFF666666),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: maxValue > 0
                                      ? maxValue / 4
                                      : 100,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xFFE0E0E0),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1,
                                    ),
                                    left: BorderSide(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                barGroups: barGroups,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    // Legend
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Income',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF44336),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expense',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Summary
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // For very small screens (< 260px), use column layout
                          // This accounts for screen width ~245px with padding
                          if (constraints.maxWidth < 260) {
                            return Column(
                              children: [
                                _buildSummaryItem(
                                  'Total Income',
                                  formatCurrency(incomeTotal),
                                  const Color(0xFF4CAF50),
                                ),
                                const SizedBox(height: 16),
                                _buildSummaryItem(
                                  'Total Expense',
                                  formatCurrency(expenseTotal),
                                  const Color(0xFFF44336),
                                ),
                                const SizedBox(height: 16),
                                _buildSummaryItem(
                                  'Balance',
                                  formatCurrency(incomeTotal - expenseTotal),
                                  (incomeTotal - expenseTotal) >= 0
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFF44336),
                                ),
                              ],
                            );
                          }
                          // For larger screens, use row layout
                          return Row(
                            children: [
                              Expanded(
                                child: _buildSummaryItem(
                                  'Total Income',
                                  formatCurrency(incomeTotal),
                                  const Color(0xFF4CAF50),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                color: const Color(0xFFE0E0E0),
                              ),
                              Expanded(
                                child: _buildSummaryItem(
                                  'Total Expense',
                                  formatCurrency(expenseTotal),
                                  const Color(0xFFF44336),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                color: const Color(0xFFE0E0E0),
                              ),
                              Expanded(
                                child: _buildSummaryItem(
                                  'Balance',
                                  formatCurrency(incomeTotal - expenseTotal),
                                  (incomeTotal - expenseTotal) >= 0
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFF44336),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Type Selector for Top Transactions
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text('Expense'),
                      ),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Top Transactions Section
              Text(
                'Top ${_selectedType}s',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              if (topTransactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'No ${_selectedType.toLowerCase()} transactions',
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...topTransactions.map((tx) {
                  final isIncome = tx.type == TransactionType.income;
                  final color = isIncome
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336);
                  final icon = isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded;

                  return Container(
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
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: color, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  tx.category,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF333333),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDateTime(tx.dateTime),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF666666),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            (isIncome ? '+' : '-') + formatCurrency(tx.amount),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
