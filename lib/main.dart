import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finai/theme/app_theme.dart';
import 'package:finai/features/auth/presentation/login_page.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';
import 'package:finai/providers/notification_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finai/config/supabase_config.dart';

/// Main entry point for the FinAI app
/// An AI-powered personal finance advisor
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

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
      ],
      child: MaterialApp(
        title: 'FinAI - Smart Finance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginPage(),
      ),
    );
  }
}
