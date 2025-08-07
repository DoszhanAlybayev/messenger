// lib/models/chat.dart

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String avatarUrl;
  final DateTime lastMessageTimestamp; // Добавляем новое поле для времени

  const Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.lastMessageTimestamp, // Обновляем конструктор
  });
}