import 'package:flutter/material.dart';
import 'package:finai/features/home/presentation/home_page.dart';
import 'package:finai/features/chat/presentation/chat_page.dart';

/// Main scaffold with bottom navigation for the app
/// Manages navigation between Home and AI Assistant screens
class BottomNavScaffold extends StatefulWidget {
  const BottomNavScaffold({super.key});

  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int _currentIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [const HomePage(), const ChatPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'AI Assistant',
          ),
        ],
      ),
    );
  }
}
