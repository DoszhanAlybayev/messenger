// lib/models/chat.dart

class Chat {
  final String id;
  final String name;
  final String? lastMessage;
  final String avatarUrl;
  final DateTime lastMessageTimestamp;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.name,
    this.lastMessage,
    required this.avatarUrl,
    required this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  Chat copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? avatarUrl,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}