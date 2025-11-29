import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finai/theme/app_theme.dart';
import 'package:finai/widgets/bottom_nav_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';
import 'package:finai/providers/notification_provider.dart';
import 'package:finai/providers/bill_provider.dart';

/// Main entry point for the FinAI app
/// An AI-powered personal finance advisor
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Hide overflow errors temporarily
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const SizedBox.shrink();
  };

  runApp(const FinAIApp());
}

class FinAIApp extends StatelessWidget {
  const FinAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => BillProvider()),
      ],
      child: MaterialApp(
        title: 'FinAI - Smart Finance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const BottomNavScaffold(),
      ),
    );
  }
}
