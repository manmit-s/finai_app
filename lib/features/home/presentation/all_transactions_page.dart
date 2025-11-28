import 'package:flutter/material.dart';
import 'package:finai/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Transaction model class
class Transaction {
  final String merchantName;
  final String category;
  final double amountUSD;
  final DateTime timestamp;
  final bool isDebit;
  final IconData categoryIcon;
  final Color categoryColor;

  Transaction({
    required this.merchantName,
    required this.category,
    required this.amountUSD,
    required this.timestamp,
    required this.isDebit,
    required this.categoryIcon,
    required this.categoryColor,
  });
}

/// All Transactions page
/// Displays complete transaction history
class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Debit', 'Credit'];

  // Mock transaction data - in production, this would come from a backend
  final List<Transaction> _allTransactions = [
    // Recent transactions (same as home page)
    Transaction(
      merchantName: 'Starbucks Coffee',
      category: 'Food',
      amountUSD: 12.50,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isDebit: true,
      categoryIcon: Icons.restaurant,
      categoryColor: const Color(0xFFFF6B6B),
    ),
    Transaction(
      merchantName: 'Netflix Subscription',
      category: 'Bills',
      amountUSD: 15.99,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isDebit: true,
      categoryIcon: Icons.receipt_long,
      categoryColor: const Color(0xFF4ECDC4),
    ),
    Transaction(
      merchantName: 'Salary Deposit',
      category: 'Income',
      amountUSD: 3500.00,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isDebit: false,
      categoryIcon: Icons.account_balance_wallet,
      categoryColor: const Color(0xFF4CAF50),
    ),
    Transaction(
      merchantName: 'Amazon Shopping',
      category: 'Shopping',
      amountUSD: 89.99,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isDebit: true,
      categoryIcon: Icons.shopping_bag,
      categoryColor: const Color(0xFF95E1D3),
    ),
    Transaction(
      merchantName: 'Uber Ride',
      category: 'Travel',
      amountUSD: 24.50,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isDebit: true,
      categoryIcon: Icons.local_taxi,
      categoryColor: const Color(0xFFFFA07A),
    ),
    // Additional transactions
    Transaction(
      merchantName: 'Walmart Groceries',
      category: 'Food',
      amountUSD: 85.30,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isDebit: true,
      categoryIcon: Icons.restaurant,
      categoryColor: const Color(0xFFFF6B6B),
    ),
    Transaction(
      merchantName: 'Electricity Bill',
      category: 'Bills',
      amountUSD: 120.00,
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
      isDebit: true,
      categoryIcon: Icons.receipt_long,
      categoryColor: const Color(0xFF4ECDC4),
    ),
    Transaction(
      merchantName: 'Gas Station',
      category: 'Travel',
      amountUSD: 45.00,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isDebit: true,
      categoryIcon: Icons.local_gas_station,
      categoryColor: const Color(0xFFFFA07A),
    ),
    Transaction(
      merchantName: 'Best Buy Electronics',
      category: 'Shopping',
      amountUSD: 299.99,
      timestamp: DateTime.now().subtract(const Duration(days: 8)),
      isDebit: true,
      categoryIcon: Icons.shopping_bag,
      categoryColor: const Color(0xFF95E1D3),
    ),
    Transaction(
      merchantName: 'Freelance Payment',
      category: 'Income',
      amountUSD: 850.00,
      timestamp: DateTime.now().subtract(const Duration(days: 9)),
      isDebit: false,
      categoryIcon: Icons.account_balance_wallet,
      categoryColor: const Color(0xFF4CAF50),
    ),
    Transaction(
      merchantName: 'Restaurant Dinner',
      category: 'Food',
      amountUSD: 68.75,
      timestamp: DateTime.now().subtract(const Duration(days: 10)),
      isDebit: true,
      categoryIcon: Icons.restaurant,
      categoryColor: const Color(0xFFFF6B6B),
    ),
    Transaction(
      merchantName: 'Spotify Premium',
      category: 'Bills',
      amountUSD: 9.99,
      timestamp: DateTime.now().subtract(const Duration(days: 11)),
      isDebit: true,
      categoryIcon: Icons.receipt_long,
      categoryColor: const Color(0xFF4ECDC4),
    ),
    Transaction(
      merchantName: 'Target Shopping',
      category: 'Shopping',
      amountUSD: 134.50,
      timestamp: DateTime.now().subtract(const Duration(days: 12)),
      isDebit: true,
      categoryIcon: Icons.shopping_bag,
      categoryColor: const Color(0xFF95E1D3),
    ),
    Transaction(
      merchantName: 'Airport Taxi',
      category: 'Travel',
      amountUSD: 55.00,
      timestamp: DateTime.now().subtract(const Duration(days: 13)),
      isDebit: true,
      categoryIcon: Icons.local_taxi,
      categoryColor: const Color(0xFFFFA07A),
    ),
    Transaction(
      merchantName: 'Coffee Shop',
      category: 'Food',
      amountUSD: 8.50,
      timestamp: DateTime.now().subtract(const Duration(days: 14)),
      isDebit: true,
      categoryIcon: Icons.restaurant,
      categoryColor: const Color(0xFFFF6B6B),
    ),
    Transaction(
      merchantName: 'Internet Bill',
      category: 'Bills',
      amountUSD: 79.99,
      timestamp: DateTime.now().subtract(const Duration(days: 15)),
      isDebit: true,
      categoryIcon: Icons.receipt_long,
      categoryColor: const Color(0xFF4ECDC4),
    ),
    Transaction(
      merchantName: 'Investment Return',
      category: 'Income',
      amountUSD: 425.00,
      timestamp: DateTime.now().subtract(const Duration(days: 16)),
      isDebit: false,
      categoryIcon: Icons.account_balance_wallet,
      categoryColor: const Color(0xFF4CAF50),
    ),
    Transaction(
      merchantName: 'Nike Store',
      category: 'Shopping',
      amountUSD: 159.99,
      timestamp: DateTime.now().subtract(const Duration(days: 17)),
      isDebit: true,
      categoryIcon: Icons.shopping_bag,
      categoryColor: const Color(0xFF95E1D3),
    ),
    Transaction(
      merchantName: 'Fast Food',
      category: 'Food',
      amountUSD: 15.25,
      timestamp: DateTime.now().subtract(const Duration(days: 18)),
      isDebit: true,
      categoryIcon: Icons.restaurant,
      categoryColor: const Color(0xFFFF6B6B),
    ),
    Transaction(
      merchantName: 'Lyft Ride',
      category: 'Travel',
      amountUSD: 18.50,
      timestamp: DateTime.now().subtract(const Duration(days: 19)),
      isDebit: true,
      categoryIcon: Icons.local_taxi,
      categoryColor: const Color(0xFFFFA07A),
    ),
    Transaction(
      merchantName: 'Phone Bill',
      category: 'Bills',
      amountUSD: 65.00,
      timestamp: DateTime.now().subtract(const Duration(days: 20)),
      isDebit: true,
      categoryIcon: Icons.receipt_long,
      categoryColor: const Color(0xFF4ECDC4),
    ),
  ];

  List<Transaction> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _allTransactions;
    } else if (_selectedFilter == 'Debit') {
      return _allTransactions.where((t) => t.isDebit).toList();
    } else {
      return _allTransactions.where((t) => !t.isDebit).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final filteredList = _filteredTransactions;

    // Calculate totals
    final totalDebit = _allTransactions
        .where((t) => t.isDebit)
        .fold<double>(0, (sum, t) => sum + t.amountUSD);
    final totalCredit = _allTransactions
        .where((t) => !t.isDebit)
        .fold<double>(0, (sum, t) => sum + t.amountUSD);

    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions'), centerTitle: false),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Spent',
                    amount: userData.formatCurrency(totalDebit),
                    color: Theme.of(context).colorScheme.error,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Received',
                    amount: userData.formatCurrency(totalCredit),
                    color: const Color(0xFF4CAF50),
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Transaction Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredList.length} transaction${filteredList.length != 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Transactions List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, thickness: 1),
                    itemBuilder: (context, index) {
                      final transaction = filteredList[index];
                      return TransactionListItem(
                        merchantName: transaction.merchantName,
                        category: transaction.category,
                        amountUSD: transaction.amountUSD,
                        timestamp: transaction.timestamp,
                        isDebit: transaction.isDebit,
                        categoryIcon: transaction.categoryIcon,
                        categoryColor: transaction.categoryColor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Summary card widget for total spent/received
class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
