import 'package:flutter/material.dart';
import 'package:finai/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:finai/features/chat/presentation/widgets/quick_reply_chip.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';

/// Model class for chat messages
class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

/// Chat page - AI Assistant interface
/// Provides a conversational interface for financial advice and insights
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Add initial bot messages
    setState(() {
      _messages.addAll([
        ChatMessage(
          message:
              'Hello! I\'m your FinAI assistant. How can I help you manage your finances today?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          message:
              'Your spending on subscriptions increased by 15% this month. Would you like to review them?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ]);
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(message: text, isUser: true, timestamp: DateTime.now()),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            message: _getAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      // Scroll to bottom after AI response
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  String _getAIResponse(String userMessage) {
    final userData = Provider.of<UserData>(context, listen: false);
    // Simple mock responses based on keywords
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('summary') || lowerMessage.contains('monthly')) {
      return 'Your monthly summary: Total spend: ${userData.formatCurrency(2450)} | Savings: ${userData.formatCurrency(850)} | Top category: Bills (${userData.formatCurrency(890)}). You\'re on track with your budget!';
    } else if (lowerMessage.contains('save') ||
        lowerMessage.contains('saving')) {
      return 'Based on your financial health score, consider starting an emergency fund. I recommend saving 20% of your income. Would you like help setting up automatic transfers?';
    } else if (lowerMessage.contains('suspicious') ||
        lowerMessage.contains('fraud')) {
      return 'I haven\'t detected any suspicious transactions recently. All your transactions appear normal. I\'m monitoring your account 24/7 for any anomalies.';
    } else if (lowerMessage.contains('budget') ||
        lowerMessage.contains('limit')) {
      return 'I can help you set spending limits! Your current food spending is ${userData.formatCurrency(650)}/month. Would you like to set a budget for this category?';
    } else {
      return 'I understand you\'re asking about ${userMessage.split(' ').take(3).join(' ')}. Let me analyze your financial data and provide personalized insights.';
    }
  }

  void _handleQuickReply(String message) {
    _messageController.text = message;
    _sendMessage(message);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinAI Assistant',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageBubble(
                        message: message.message,
                        isUser: message.isUser,
                        timestamp: message.timestamp,
                      );
                    },
                  ),
          ),

          // Quick reply suggestions
          if (_messages.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    QuickReplyChip(
                      label: 'Monthly summary',
                      icon: Icons.calendar_month,
                      onTap: () => _handleQuickReply('Show my monthly summary'),
                    ),
                    const SizedBox(width: 8),
                    QuickReplyChip(
                      label: 'Saving tips',
                      icon: Icons.savings,
                      onTap: () =>
                          _handleQuickReply('How can I save more this month?'),
                    ),
                    const SizedBox(width: 8),
                    QuickReplyChip(
                      label: 'Check alerts',
                      icon: Icons.warning_amber,
                      onTap: () =>
                          _handleQuickReply('Any suspicious transactions?'),
                    ),
                    const SizedBox(width: 8),
                    QuickReplyChip(
                      label: 'Set budget',
                      icon: Icons.account_balance_wallet,
                      onTap: () => _handleQuickReply('Help me set a budget'),
                    ),
                  ],
                ),
              ),
            ),

          // Message input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about your finances...',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.psychology,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your AI Financial Coach',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your finances',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
