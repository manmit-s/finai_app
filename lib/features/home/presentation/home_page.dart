import 'package:flutter/material.dart';
import 'package:finai/features/home/presentation/widgets/financial_health_card.dart';
import 'package:finai/features/home/presentation/widgets/stat_card.dart';
import 'package:finai/features/home/presentation/widgets/spending_chart.dart';
import 'package:finai/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:finai/features/account/presentation/account_page.dart';
import 'package:finai/features/home/presentation/all_transactions_page.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Home page - Main dashboard for the FinAI app
/// Displays financial health score, stats, spending overview, and recent transactions
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Consumer<UserData>(
              builder: (context, userData, child) => Text(
                userData.userName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh logic here
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Health Score Card
                Center(
                  child: FinancialHealthCard(
                    //Calculated Health Score
                    score: 78,
                    status: 'Good',
                    statusColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Stats Row
                Consumer<UserData>(
                  builder: (context, userData, child) => Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Spend',
                          value: userData.formatCurrency(2450),
                          icon: Icons.trending_down,
                          iconColor: Theme.of(context).colorScheme.error,
                          subtitle: 'This month',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Savings',
                          value: userData.formatCurrency(850),
                          icon: Icons.savings_outlined,
                          iconColor: const Color(0xFF4CAF50),
                          subtitle: 'Surplus',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                StatCard(
                  title: 'Upcoming Bills',
                  value: '3 bills',
                  icon: Icons.notifications_active_outlined,
                  iconColor: const Color(0xFFFF9800),
                  subtitle: 'Due this week',
                ),
                const SizedBox(height: 32),

                // Spending Overview Section
                _SectionHeader(
                  title: 'Spending Overview',
                  subtitle: 'Last 30 days',
                ),
                const SizedBox(height: 16),
                Consumer<UserData>(
                  builder: (context, userData, child) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SpendingChart(
                        categories: [
                          CategorySpending(
                            name: 'Food',
                            amount: userData.convertFromUSD(650),
                            icon: Icons.restaurant,
                            color: const Color(0xFFFF6B6B),
                            currencySymbol: userData.currencySymbol,
                          ),
                          CategorySpending(
                            name: 'Bills',
                            amount: userData.convertFromUSD(890),
                            icon: Icons.receipt_long,
                            color: const Color(0xFF4ECDC4),
                            currencySymbol: userData.currencySymbol,
                          ),
                          CategorySpending(
                            name: 'Shopping',
                            amount: userData.convertFromUSD(450),
                            icon: Icons.shopping_bag,
                            color: const Color(0xFF95E1D3),
                            currencySymbol: userData.currencySymbol,
                          ),
                          CategorySpending(
                            name: 'Travel',
                            amount: userData.convertFromUSD(320),
                            icon: Icons.flight,
                            color: const Color(0xFFFFA07A),
                            currencySymbol: userData.currencySymbol,
                          ),
                          CategorySpending(
                            name: 'Others',
                            amount: userData.convertFromUSD(140),
                            icon: Icons.more_horiz,
                            color: const Color(0xFFB8B8D1),
                            currencySymbol: userData.currencySymbol,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // AI Insights Card
                Card(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Insight',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You spent 30% more on food this week. Consider setting a weekly limit to stay on track.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Recent Transactions Section
                _SectionHeader(
                  title: 'Recent Transactions',
                  actionText: 'View All',
                  onActionTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllTransactionsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Consumer<UserData>(
                  builder: (context, userData, child) => Card(
                    child: Column(
                      children: [
                        TransactionListItem(
                          merchantName: 'Starbucks Coffee',
                          category: 'Food',
                          amountUSD: 12.50,
                          timestamp: DateTime.now().subtract(
                            const Duration(hours: 2),
                          ),
                          isDebit: true,
                          categoryIcon: Icons.restaurant,
                          categoryColor: const Color(0xFFFF6B6B),
                        ),
                        const Divider(height: 1),
                        TransactionListItem(
                          merchantName: 'Netflix Subscription',
                          category: 'Bills',
                          amountUSD: 15.99,
                          timestamp: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          isDebit: true,
                          categoryIcon: Icons.receipt_long,
                          categoryColor: const Color(0xFF4ECDC4),
                        ),
                        const Divider(height: 1),
                        TransactionListItem(
                          merchantName: 'Salary Deposit',
                          category: 'Income',
                          amountUSD: 3500.00,
                          timestamp: DateTime.now().subtract(
                            const Duration(days: 2),
                          ),
                          isDebit: false,
                          categoryIcon: Icons.account_balance_wallet,
                          categoryColor: const Color(0xFF4CAF50),
                        ),
                        const Divider(height: 1),
                        TransactionListItem(
                          merchantName: 'Amazon Shopping',
                          category: 'Shopping',
                          amountUSD: 89.99,
                          timestamp: DateTime.now().subtract(
                            const Duration(days: 3),
                          ),
                          isDebit: true,
                          categoryIcon: Icons.shopping_bag,
                          categoryColor: const Color(0xFF95E1D3),
                        ),
                        const Divider(height: 1),
                        TransactionListItem(
                          merchantName: 'Uber Ride',
                          category: 'Travel',
                          amountUSD: 24.50,
                          timestamp: DateTime.now().subtract(
                            const Duration(days: 4),
                          ),
                          isDebit: true,
                          categoryIcon: Icons.local_taxi,
                          categoryColor: const Color(0xFFFFA07A),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
          ],
        ),
        if (actionText != null && onActionTap != null)
          TextButton(onPressed: onActionTap, child: Text(actionText!)),
      ],
    );
  }
}
