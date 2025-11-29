import 'package:flutter/foundation.dart';

/// Currency enum for supported currencies
enum Currency {
  usd('USD', '\$', 'US Dollar'),
  inr('INR', '₹', 'Indian Rupee');

  const Currency(this.code, this.symbol, this.name);
  final String code;
  final String symbol;
  final String name;
}

/// User data provider for managing user information across the app
class UserData extends ChangeNotifier {
  String _userName = 'Alex';
  String _email = 'alex@finai.com';
  String _phoneNumber = '+1 234 567 8900';
  DateTime _dateOfBirth = DateTime(1995, 5, 15);
  Currency _currency = Currency.inr;

  // Getters
  String get userName => _userName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  DateTime get dateOfBirth => _dateOfBirth;
  Currency get currency => _currency;

  // Setters with notifications
  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void updateDateOfBirth(DateTime dob) {
    _dateOfBirth = dob;
    notifyListeners();
  }

  void updateCurrency(Currency currency) {
    _currency = currency;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    DateTime? dob,
  }) {
    if (name != null) _userName = name;
    if (email != null) _email = email;
    if (phone != null) _phoneNumber = phone;
    if (dob != null) _dateOfBirth = dob;
    notifyListeners();
  }

  /// Format currency with proper symbol (amounts stored in INR)
  String formatCurrency(double amount, {bool showSymbol = true}) {
    if (showSymbol) {
      return '${_currency.symbol}${amount.toStringAsFixed(2)}';
    }
    return amount.toStringAsFixed(2);
  }

  /// Get currency symbol
  String get currencySymbol => _currency.symbol;

  /// Get currency code
  String get currencyCode => _currency.code;
}
