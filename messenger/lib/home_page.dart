// lib/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Индекс выбранного пункта в навигационной панели

  // Список виджетов, которые будут отображаться по центру
  static final List<Widget> _widgetOptions = <Widget>[
    // Здесь мы пока будем просто отображать заглушки
    // Позже мы заменим их на реальные экраны
    const Center(child: Text('Переписки (Чаты)')),
    const Center(child: Text('Поиск пользователей')),
    const Center(child: Text('Настройки')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Верхний навбар ---
      appBar: AppBar(
        title: const Text('Мессенджер'),
      ),
      
      // --- Центральная часть (содержимое) ---
      body: _widgetOptions.elementAt(_selectedIndex),
      
      // --- Нижний навбар ---
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Добавить',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}