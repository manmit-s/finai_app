import 'package:flutter/material.dart';
import 'package:finai/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:finai/features/chat/presentation/widgets/quick_reply_chip.dart';
import 'package:provider/provider.dart';
import 'package:finai/providers/user_data.dart';
import 'package:finai/services/finai_api_service.dart';

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
  final FinAIApiService _apiService = FinAIApiService();
  bool _isLoading = false;

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

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(message: text, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Get financial context from user data
    final userData = Provider.of<UserData>(context, listen: false);
    final financialContext = _buildFinancialContext(userData);

    try {
      // Call real API
      final response = await _apiService.sendPrompt(
        prompt: text,
        context: financialContext,
      );

      setState(() {
        _messages.add(
          ChatMessage(
            message: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _messages.add(
          ChatMessage(
            message:
                'Sorry, I encountered an error: ${e.toString()}. Please try again.',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }

    // Scroll to bottom after AI response
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Builds financial context from user data to send with API request
  Map<String, dynamic> _buildFinancialContext(UserData userData) {
    return {
      'currency': userData.currencyCode,
      'financial_health_score': 78,
      'monthly_spending': 2450.00,
      'monthly_savings': 850.00,
      'spending_by_category': {
        'Bills': 890.00,
        'Food': 650.00,
        'Shopping': 480.00,
        'Travel': 220.00,
        'Entertainment': 210.00,
      },
      'recent_transactions': [
        {'merchant': 'Starbucks Coffee', 'amount': 12.50, 'category': 'Food'},
        {
          'merchant': 'Netflix Subscription',
          'amount': 15.99,
          'category': 'Bills',
        },
        {
          'merchant': 'Amazon Shopping',
          'amount': 89.99,
          'category': 'Shopping',
        },
      ],
      'user_name': userData.userName,
    };
  }

  void _handleQuickReply(String message) {
    _messageController.text = message;
    _sendMessage(message);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _apiService.dispose();
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
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end
                      if (index == _messages.length && _isLoading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'FinAI is thinking...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

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
