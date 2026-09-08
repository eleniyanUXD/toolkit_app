import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';

class AiMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const AiMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Colors.blue
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}