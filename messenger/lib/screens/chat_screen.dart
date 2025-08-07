// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import 'package:messenger/models/chat.dart';
import 'package:messenger/bloc/chat_bloc.dart';
import 'package:messenger/bloc/chat_event.dart';
import 'package:messenger/bloc/chat_state.dart';
import 'package:messenger/widgets/message_bubble.dart'; 

class ChatScreen extends StatelessWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: ChatView(chat: chat),
    );
  }
}

class ChatView extends StatefulWidget {
  final Chat chat;
  const ChatView({super.key, required this.chat});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(text));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Отключаем автоматический pop
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        // Передаем последнее сообщение обратно
        Navigator.pop(context, _textController.text);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.chat.avatarUrl),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Text(widget.chat.name),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[state.messages.length - 1 - index];
                        final isMe = message.sender == 'Я';
                        final formattedTime = DateFormat('HH:mm').format(message.timestamp);

                        return MessageBubble(
                          text: message.text,
                          isMe: isMe,
                          time: formattedTime,
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            _buildTextComposer(_textController, _handleSubmitted),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer(TextEditingController controller, Function(String) onSubmitted) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 8.0),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Сообщение',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => onSubmitted(controller.text),
          ),
        ],
      ),
    );
  }
}