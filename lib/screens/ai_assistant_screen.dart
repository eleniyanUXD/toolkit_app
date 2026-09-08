import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../widgets/ai_input_field.dart';
import '../widgets/ai_message_bubble.dart';
import '../widgets/ai_suggestion_chip.dart';
import '../services/ai_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AiService _aiService = AiService();

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(
        ChatMessage(message: message, isUser: true, timestamp: DateTime.now()),
      );

      _isLoading = true;
    });

    _messageController.clear();

    try {
      final aiResponse = await _aiService.sendMessage(message);

      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            message: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            message: 'Error: $e',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );

        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Assistant',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessages(),
              ),
              const SizedBox(height: 16),
              AiInputField(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.blue, size: 34),
          ),

          const SizedBox(height: 20),

          const Text(
            'How can I help you?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            'Ask me anything or get help using Toolkit.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 24),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              AiSuggestionChip(
                text: 'Convert 10 miles to km',
                onTap: () {
                  _messageController.text = 'Convert 10 miles to km';
                },
              ),

              AiSuggestionChip(
                text: 'Calculate 15% of 50000',
                onTap: () {
                  _messageController.text = 'Calculate 15% of 50000';
                },
              ),

              AiSuggestionChip(
                text: 'Help me use a tool',
                onTap: () {
                  _messageController.text = 'Help me use a tool';
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        return AiMessageBubble(message: _messages[index]);
      },
    );
  }
}
