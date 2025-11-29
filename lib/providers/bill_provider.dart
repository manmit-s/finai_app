import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finai/models/bill.dart';

/// Provider for managing bills
class BillProvider extends ChangeNotifier {
  final List<Bill> _bills = [
    Bill(
      id: '1',
      name: 'Netflix Subscription',
      amount: 649.00,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      category: 'Entertainment',
      icon: Icons.movie_outlined,
      color: const Color(0xFFE50914),
    ),
    Bill(
      id: '2',
      name: 'Electricity Bill',
      amount: 1850.00,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      category: 'Utilities',
      icon: Icons.bolt_outlined,
      color: const Color(0xFFFFC107),
    ),
    Bill(
      id: '3',
      name: 'Internet Bill',
      amount: 999.00,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      category: 'Utilities',
      icon: Icons.wifi_outlined,
      color: const Color(0xFF2196F3),
    ),
  ];

  List<Bill> get bills => List.unmodifiable(_bills);

  /// Get pending bills (not paid)
  List<Bill> get pendingBills =>
      _bills.where((bill) => !bill.isPaid).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  /// Get paid bills
  List<Bill> get paidBills =>
      _bills.where((bill) => bill.isPaid).toList()
        ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

  /// Get overdue bills
  List<Bill> get overdueBills =>
      _bills.where((bill) => bill.isOverdue).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  /// Get bills due this week
  List<Bill> get billsDueThisWeek =>
      _bills.where((bill) => bill.isDueSoon).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  /// Get count of pending bills
  int get pendingBillsCount => pendingBills.length;

  /// Add a new bill
  void addBill(Bill bill) {
    _bills.add(bill);
    notifyListeners();
  }

  /// Mark bill as paid
  void markAsPaid(String billId) {
    final index = _bills.indexWhere((bill) => bill.id == billId);
    if (index != -1) {
      _bills[index] = _bills[index].copyWith(isPaid: true);
      notifyListeners();
    }
  }

  /// Mark bill as unpaid
  void markAsUnpaid(String billId) {
    final index = _bills.indexWhere((bill) => bill.id == billId);
    if (index != -1) {
      _bills[index] = _bills[index].copyWith(isPaid: false);
      notifyListeners();
    }
  }

  /// Delete a bill
  void deleteBill(String billId) {
    _bills.removeWhere((bill) => bill.id == billId);
    notifyListeners();
  }

  /// Update a bill
  void updateBill(Bill updatedBill) {
    final index = _bills.indexWhere((bill) => bill.id == updatedBill.id);
    if (index != -1) {
      _bills[index] = updatedBill;
      notifyListeners();
    }
  }
}
