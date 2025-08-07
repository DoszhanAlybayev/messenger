import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/chat_bloc.dart';
import 'package:messenger/bloc/chat_event.dart';
import 'package:messenger/bloc/chat_state.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();

    void _handleSubmitted(String text) {
      if (text.isEmpty) return;
      context.read<ChatBloc>().add(SendMessage(text));
      _textController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Демо-чат (Bloc)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[state.messages.length - 1 - index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text(message.sender),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(_textController, _handleSubmitted),
        ],
      ),
    );
  }

  Widget _buildTextComposer(TextEditingController controller, Function(String) onSubmitted) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration.collapsed(hintText: 'Отправить сообщение'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => onSubmitted(controller.text),
          ),
        ],
      ),
    );
  }
}