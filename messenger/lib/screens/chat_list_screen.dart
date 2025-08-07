// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:messenger/models/chat.dart'; 

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // Статический список чатов для имитации данных
  final List<Chat> _dummyChats = const [
    Chat(
      id: '1',
      name: 'Анна',
      lastMessage: 'Привет, как дела?',
      avatarUrl: 'https://via.placeholder.com/150',
    ),
    Chat(
      id: '2',
      name: 'Иван',
      lastMessage: 'Уже закончил работу?',
      avatarUrl: 'https://via.placeholder.com/150',
    ),
    Chat(
      id: '3',
      name: 'Команда Мессенджер',
      lastMessage: 'Приветствуем в нашем приложении!',
      avatarUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            onTap: () {
              // Здесь будет навигация на экран чата
              // Пока просто покажем сообщение
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Переход в чат с ${chat.name}...')),
              );
            },
          );
        },
      ),
    );
  }
}