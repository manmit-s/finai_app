import 'package:flutter/foundation.dart';

/// Notification data model
class NotificationData {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  bool isUnread;

  NotificationData({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isUnread = true,
  });
}

/// Notification provider for managing app notifications
class NotificationProvider extends ChangeNotifier {
  final List<NotificationData> _notifications = [
    NotificationData(
      id: '1',
      title: 'Anomaly Detected',
      description:
          'Unusual spending pattern detected: \$450 spent on electronics in the last 24 hours - 3x your average daily spending.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: true,
    ),
    NotificationData(
      id: '2',
      title: 'High-Risk Transaction Alert',
      description:
          'A large transaction of \$1,250 was attempted from an unusual location. Please verify if this was you.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isUnread: true,
    ),
    NotificationData(
      id: '3',
      title: 'Budget Alert Resolved',
      description: 'You\'re back on track with your monthly budget goals.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
    ),
    NotificationData(
      id: '4',
      title: 'Savings Milestone',
      description:
          'Congratulations! You\'ve saved 20% more this month compared to last month.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isUnread: false,
    ),
  ];

  List<NotificationData> get notifications => _notifications;

  int get unreadCount =>
      _notifications.where((notification) => notification.isUnread).length;

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isUnread = false;
    }
    notifyListeners();
  }

  void markAsRead(String id) {
    final notification = _notifications.firstWhere(
      (notification) => notification.id == id,
    );
    notification.isUnread = false;
    notifyListeners();
  }

  void addNotification(NotificationData notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
