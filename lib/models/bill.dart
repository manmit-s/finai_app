import 'package:flutter/material.dart';

/// Model for a bill
class Bill {
  final String id;
  final String name;
  final double amount;
  final DateTime dueDate;
  final String category;
  final bool isPaid;
  final IconData icon;
  final Color color;

  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDate,
    required this.category,
    this.isPaid = false,
    required this.icon,
    required this.color,
  });

  Bill copyWith({
    String? id,
    String? name,
    double? amount,
    DateTime? dueDate,
    String? category,
    bool? isPaid,
    IconData? icon,
    Color? color,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isPaid: isPaid ?? this.isPaid,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  /// Check if bill is overdue
  bool get isOverdue => !isPaid && dueDate.isBefore(DateTime.now());

  /// Check if bill is due soon (within 7 days)
  bool get isDueSoon {
    if (isPaid) return false;
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  /// Get days until due (negative if overdue)
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
}
