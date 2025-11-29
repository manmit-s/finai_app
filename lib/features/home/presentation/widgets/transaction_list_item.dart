import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Reusable transaction list item widget
/// Displays transaction details with merchant, category, amount, and timestamp
class TransactionListItem extends StatelessWidget {
  final String merchantName;
  final String category;
  final double amountUSD;
  final DateTime timestamp;
  final bool isDebit;
  final IconData categoryIcon;
  final Color categoryColor;

  const TransactionListItem({
    super.key,
    required this.merchantName,
    required this.category,
    required this.amountUSD,
    required this.timestamp,
    required this.isDebit,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isDebit
        ? Theme.of(context).colorScheme.error
        : const Color(0xFF4CAF50);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          // Category icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 24),
          ),
          const SizedBox(width: 12),
          // Merchant and category info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchantName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          color: categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Timestamp
                    Text(
                      _formatTimestamp(timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Amount
          Consumer<UserData>(
            builder: (context, userData, child) {
              return Text(
                '${isDebit ? '-' : '+'}${userData.currencySymbol}${amountUSD.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
