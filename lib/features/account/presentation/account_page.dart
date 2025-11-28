import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Account management page
/// Allows users to manage profile, preferences, and app settings
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // User profile data (in production, this would come from a backend)
  String _userName = 'Alex';
  String _email = 'alex@finai.com';
  String _phoneNumber = '+1 234 567 8900';
  DateTime _dateOfBirth = DateTime(1995, 5, 15);
  ThemeMode _themeMode = ThemeMode.system;

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Initialize from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = Provider.of<UserData>(context, listen: false);
      setState(() {
        _userName = userData.userName;
        _email = userData.email;
        _phoneNumber = userData.phoneNumber;
        _dateOfBirth = userData.dateOfBirth;
      });
      _nameController.text = _userName;
      _emailController.text = _email;
      _phoneController.text = _phoneNumber;
    });
    _nameController = TextEditingController(text: _userName);
    _emailController = TextEditingController(text: _email);
    _phoneController = TextEditingController(text: _phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final userData = Provider.of<UserData>(context, listen: false);
              setState(() {
                _userName = _nameController.text;
                _email = _emailController.text;
                _phoneNumber = _phoneController.text;
              });
              // Update provider
              userData.updateProfile(
                name: _userName,
                email: _email,
                phone: _phoneNumber,
              );
              Navigator.pop(context);
              _showSuccessSnackBar('Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final userData = Provider.of<UserData>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
      // Update provider
      userData.updateDateOfBirth(picked);
      if (mounted) {
        _showSuccessSnackBar('Date of birth updated');
      }
    }
  }

  void _showCurrencyDialog() {
    final userData = Provider.of<UserData>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Currency>(
              title: const Text('US Dollar'),
              subtitle: const Text('\$ (USD)'),
              value: Currency.usd,
              groupValue: userData.currency,
              onChanged: (value) {
                userData.updateCurrency(value!);
                Navigator.pop(context);
                _showSuccessSnackBar('Currency changed to USD');
              },
            ),
            RadioListTile<Currency>(
              title: const Text('Indian Rupee'),
              subtitle: const Text('₹ (INR)'),
              value: Currency.inr,
              groupValue: userData.currency,
              onChanged: (value) {
                userData.updateCurrency(value!);
                Navigator.pop(context);
                _showSuccessSnackBar('Currency changed to INR');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value!;
                });
                Navigator.pop(context);
                _showSuccessSnackBar('Theme changed to Light');
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value!;
                });
                Navigator.pop(context);
                _showSuccessSnackBar('Theme changed to Dark');
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value!;
                });
                Navigator.pop(context);
                _showSuccessSnackBar('Theme set to System Default');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getThemeLabel() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings'), centerTitle: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Information Section
            _SectionHeader(title: 'Profile Information'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Name',
                    subtitle: _userName,
                    onTap: _showEditProfileDialog,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: _email,
                    onTap: _showEditProfileDialog,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    subtitle: _phoneNumber,
                    onTap: _showEditProfileDialog,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.cake_outlined,
                    title: 'Date of Birth',
                    subtitle: DateFormat('MMMM dd, yyyy').format(_dateOfBirth),
                    onTap: _selectDateOfBirth,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Appearance Section
            _SectionHeader(title: 'Appearance'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: _getThemeLabel(),
                    onTap: _showThemeDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Preferences Section
            _SectionHeader(title: 'Preferences'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notification settings',
                    onTap: () {
                      // Navigate to notifications settings
                      _showSuccessSnackBar(
                        'Notifications settings coming soon',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English (US)',
                    onTap: () {
                      // Show language picker
                      _showSuccessSnackBar('Language settings coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  Consumer<UserData>(
                    builder: (context, userData, child) => _SettingsTile(
                      icon: Icons.attach_money_outlined,
                      title: 'Currency',
                      subtitle: '${userData.currency.name} (${userData.currency.symbol})',
                      onTap: _showCurrencyDialog,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Security Section
            _SectionHeader(title: 'Security'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.lock_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      _showSuccessSnackBar('Change password coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.fingerprint_outlined,
                    title: 'Biometric Authentication',
                    subtitle: 'Enable fingerprint or face ID',
                    onTap: () {
                      _showSuccessSnackBar('Biometric auth coming soon');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Section
            _SectionHeader(title: 'About'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outlined,
                    title: 'App Version',
                    subtitle: '1.0.0',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    subtitle: 'View terms and conditions',
                    onTap: () {
                      _showSuccessSnackBar('Terms & Conditions coming soon');
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'View privacy policy',
                    onTap: () {
                      _showSuccessSnackBar('Privacy Policy coming soon');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSuccessSnackBar('Logged out successfully');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: Colors.grey.shade400)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
