// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:messenger/models/chat.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/screens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _foundUsers = [];

  final List<User> _allUsers = const [
    User(id: 'u1', name: 'Анна', avatarUrl: 'https://via.placeholder.com/150'),
    User(id: 'u2', name: 'Иван', avatarUrl: 'https://via.placeholder.com/150'),
    User(id: 'u3', name: 'Мария', avatarUrl: 'https://via.placeholder.com/150'),
    User(id: 'u4', name: 'Петр', avatarUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  void initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<User> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers.where((user) =>
        user.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
              hintText: 'Имя пользователя...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _foundUsers.length,
              itemBuilder: (context, index) {
                final user = _foundUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.name),
                  onTap: () {
                    final newChat = Chat(
                      id: user.id,
                      name: user.name,
                      avatarUrl: user.avatarUrl,
                      lastMessageTimestamp: DateTime.now(),
                      unreadCount: 0,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chat: newChat),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}