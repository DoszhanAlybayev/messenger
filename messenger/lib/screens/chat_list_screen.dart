// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
   ChatListScreen({super.key});

  // Убрали "const" перед списком
  final List<Chat> _dummyChats = [
    Chat(
      id: '1',
      name: 'Анна',
      lastMessage: 'Привет, как дела?',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Chat(
      id: '2',
      name: 'Иван',
      lastMessage: 'Уже закончил работу?',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Chat(
      id: '3',
      name: 'Команда Мессенджер',
      lastMessage: 'Приветствуем в нашем приложении!',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          final formattedTime = DateFormat('HH:mm').format(chat.lastMessageTimestamp);
          
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            trailing: Text(formattedTime),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chat: chat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}