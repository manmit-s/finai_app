import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Summary page - Displays weekly and monthly spending analysis with AI advice
class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Spending Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            const _PeriodCard(),
            const SizedBox(height: 24),

            // Weekly Spending Section
            Consumer<UserData>(
              builder: (context, userData, child) => _SpendingCard(
                title: 'Weekly Spending',
                period: 'Nov 23 - Nov 29, 2025',
                totalAmount: userData.formatCurrency(486.50),
                currencySymbol: userData.currencySymbol,
                categories: [
                  _CategoryData(
                    name: 'Food & Dining',
                    amount: userData.convertFromUSD(185.50),
                    percentage: 38,
                    icon: Icons.restaurant,
                    color: const Color(0xFFFF6B6B),
                  ),
                  _CategoryData(
                    name: 'Shopping',
                    amount: userData.convertFromUSD(145.00),
                    percentage: 30,
                    icon: Icons.shopping_bag,
                    color: const Color(0xFF95E1D3),
                  ),
                  _CategoryData(
                    name: 'Transportation',
                    amount: userData.convertFromUSD(89.00),
                    percentage: 18,
                    icon: Icons.directions_car,
                    color: const Color(0xFFFFA07A),
                  ),
                  _CategoryData(
                    name: 'Entertainment',
                    amount: userData.convertFromUSD(67.00),
                    percentage: 14,
                    icon: Icons.movie,
                    color: const Color(0xFF4ECDC4),
                  ),
                ],
                aiAdvice:
                    'Your weekly spending is on track! You are spending 15% less than your weekly average. Consider maintaining this pattern to reach your monthly savings goal.',
                adviceType: AdviceType.positive,
              ),
            ),
            const SizedBox(height: 24),

            // Monthly Spending Section
            Consumer<UserData>(
              builder: (context, userData, child) => _SpendingCard(
                title: 'Monthly Spending',
                period: 'November 2025',
                totalAmount: userData.formatCurrency(2450.00),
                currencySymbol: userData.currencySymbol,
                categories: [
                  _CategoryData(
                    name: 'Bills & Utilities',
                    amount: userData.convertFromUSD(890.00),
                    percentage: 36,
                    icon: Icons.receipt_long,
                    color: const Color(0xFF4ECDC4),
                  ),
                  _CategoryData(
                    name: 'Food & Dining',
                    amount: userData.convertFromUSD(650.00),
                    percentage: 27,
                    icon: Icons.restaurant,
                    color: const Color(0xFFFF6B6B),
                  ),
                  _CategoryData(
                    name: 'Shopping',
                    amount: userData.convertFromUSD(450.00),
                    percentage: 18,
                    icon: Icons.shopping_bag,
                    color: const Color(0xFF95E1D3),
                  ),
                  _CategoryData(
                    name: 'Transportation',
                    amount: userData.convertFromUSD(320.00),
                    percentage: 13,
                    icon: Icons.local_taxi,
                    color: const Color(0xFFFFA07A),
                  ),
                  _CategoryData(
                    name: 'Others',
                    amount: userData.convertFromUSD(140.00),
                    percentage: 6,
                    icon: Icons.more_horiz,
                    color: const Color(0xFFB8B8D1),
                  ),
                ],
                aiAdvice:
                    'Alert: You are 12% over your monthly budget. Your food spending increased by 30% compared to last month. Try meal prepping to reduce dining costs, and consider reviewing your subscription services.',
                adviceType: AdviceType.warning,
              ),
            ),
            const SizedBox(height: 24),

            // Comparison Card
            const _ComparisonCard(),
            const SizedBox(height: 24),

            // Insights Section
            const _InsightsSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Period selector card
class _PeriodCard extends StatelessWidget {
  const _PeriodCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Period',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Current Week & Month',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.calendar_today,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/// Spending card widget
class _SpendingCard extends StatelessWidget {
  final String title;
  final String period;
  final String totalAmount;
  final String currencySymbol;
  final List<_CategoryData> categories;
  final String aiAdvice;
  final AdviceType adviceType;

  const _SpendingCard({
    required this.title,
    required this.period,
    required this.totalAmount,
    required this.currencySymbol,
    required this.categories,
    required this.aiAdvice,
    required this.adviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      period,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    totalAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Category Breakdown
            ...categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CategoryItem(
                  category: category,
                  currencySymbol: currencySymbol,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // AI Advice Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getAdviceColor(adviceType, context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getAdviceIcon(adviceType),
                    color: _getAdviceIconColor(adviceType, context),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Financial Advice',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getAdviceIconColor(adviceType, context),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          aiAdvice,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAdviceColor(AdviceType type, BuildContext context) {
    switch (type) {
      case AdviceType.positive:
        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
      case AdviceType.warning:
        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
      case AdviceType.alert:
        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }
  }

  IconData _getAdviceIcon(AdviceType type) {
    switch (type) {
      case AdviceType.positive:
        return Icons.check_circle_outline;
      case AdviceType.warning:
        return Icons.warning_amber_outlined;
      case AdviceType.alert:
        return Icons.error_outline;
    }
  }

  Color _getAdviceIconColor(AdviceType type, BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}

/// Category item widget
class _CategoryItem extends StatelessWidget {
  final _CategoryData category;
  final String currencySymbol;

  const _CategoryItem({required this.category, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: category.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${category.percentage}% of total',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$currencySymbol${category.amount.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: category.percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(category.color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Comparison card widget
class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Comparison',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const _ComparisonItem(
              label: 'vs. Last Week',
              percentage: -15,
              isPositive: true,
            ),
            const SizedBox(height: 12),
            const _ComparisonItem(
              label: 'vs. Last Month',
              percentage: 12,
              isPositive: false,
            ),
            const SizedBox(height: 12),
            const _ComparisonItem(
              label: 'vs. Average',
              percentage: 8,
              isPositive: false,
            ),
          ],
        ),
      ),
    );
  }
}

/// Comparison item widget
class _ComparisonItem extends StatelessWidget {
  final String label;
  final int percentage;
  final bool isPositive;

  const _ComparisonItem({
    required this.label,
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_down : Icons.trending_up,
              color: isPositive ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              '${percentage.abs()}%',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Insights section widget
class _InsightsSection extends StatelessWidget {
  const _InsightsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Insights',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const _InsightCard(
          icon: Icons.lightbulb_outline,
          iconColor: Colors.amber,
          title: 'Best Saving Day',
          description: 'Monday - You spend 40% less on Mondays',
        ),
        const SizedBox(height: 12),
        const _InsightCard(
          icon: Icons.shopping_cart,
          iconColor: Colors.blue,
          title: 'Top Spending Category',
          description: 'Bills & Utilities - Consider reviewing subscriptions',
        ),
        const SizedBox(height: 12),
        const _InsightCard(
          icon: Icons.local_fire_department,
          iconColor: Colors.red,
          title: 'Spending Streak',
          description: '5 days of staying under daily budget',
        ),
      ],
    );
  }
}

/// Insight card widget
class _InsightCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _InsightCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category data model
class _CategoryData {
  final String name;
  final double amount;
  final int percentage;
  final IconData icon;
  final Color color;

  _CategoryData({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.icon,
    required this.color,
  });
}

/// Advice type enum
enum AdviceType { positive, warning, alert }
