import 'package:flutter/material.dart';

/// Simple bar chart widget for spending overview
/// Shows spending distribution across different categories
class SpendingChart extends StatelessWidget {
  final List<CategorySpending> categories;

  const SpendingChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    final maxAmount = categories
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        // Bar chart
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.map((category) {
              final heightPercent = (category.amount / maxAmount);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Amount label
                      Text(
                        '${category.currencySymbol}${category.amount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        height: heightPercent * 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              category.color,
                              category.color.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Category icon
                      Icon(category.icon, size: 20, color: category.color),
                      const SizedBox(height: 4),
                      // Category name
                      Text(
                        category.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 11),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Model class for category spending data
class CategorySpending {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;
  final String currencySymbol;

  CategorySpending({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
    this.currencySymbol = '\$',
  });
}
