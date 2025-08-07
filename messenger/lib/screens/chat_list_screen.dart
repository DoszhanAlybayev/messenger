// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/screens/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Переносим список в State, чтобы его можно было изменять
  final List<Chat> _dummyChats = [
    Chat(
      id: '1',
      name: 'Анна',
      lastMessage: 'Привет, как дела?',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    Chat(
      id: '2',
      name: 'Иван',
      lastMessage: 'Уже закончил работу?',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
    Chat(
      id: '3',
      name: 'Команда Мессенджер',
      lastMessage: 'Приветствуем в нашем приложении!',
      avatarUrl: 'https://via.placeholder.com/150',
      lastMessageTimestamp: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 5,
    ),
  ];

  // Функция для динамического форматирования времени
  String _formatChatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (date.isAtSameMomentAs(today)) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (date.isAtSameMomentAs(yesterday)) {
      return 'Вчера';
    } else {
      return DateFormat('dd/MM/yy').format(timestamp);
    }
  }

  // Обновляем onTap для работы с асинхронной навигацией
  void _onChatTapped(Chat chat) async {
    // Находим индекс текущего чата
    final chatIndex = _dummyChats.indexWhere((c) => c.id == chat.id);

    // Сбрасываем счетчик и обновляем состояние, чтобы UI изменился сразу
    if (chatIndex != -1) {
      setState(() {
        _dummyChats[chatIndex] = _dummyChats[chatIndex].copyWith(unreadCount: 0);
      });
    }

    // Переходим на экран чата и ждём результат
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(chat: _dummyChats[chatIndex]),
      ),
    );

    // Если мы получили результат из ChatScreen
    if (result != null) {
      setState(() {
        final lastMessage = result as String; // Предположим, что мы передали последнее сообщение
        _dummyChats[chatIndex] = _dummyChats[chatIndex].copyWith(
          lastMessage: lastMessage,
          lastMessageTimestamp: DateTime.now(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _dummyChats.length,
        itemBuilder: (context, index) {
          final chat = _dummyChats[index];
          final formattedTime = _formatChatTime(chat.lastMessageTimestamp);
          
          Widget trailingWidget;
          if (chat.unreadCount > 0) {
            trailingWidget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedTime,
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            );
          } else {
            trailingWidget = Text(formattedTime);
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat.avatarUrl),
            ),
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            trailing: trailingWidget,
            onTap: () => _onChatTapped(chat),
          );
        },
      ),
    );
  }
}