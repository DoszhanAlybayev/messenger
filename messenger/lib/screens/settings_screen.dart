// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:messenger/widgets/profile_avatar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? 'Иван Иванов';
      _aboutController.text = prefs.getString('user_about') ?? 'Привет, я новый пользователь мессенджера!';
      
      final String? imagePath = prefs.getString('user_avatar_path');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  Future<void> _saveProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_about', _aboutController.text);
    if (_image != null) {
      await prefs.setString('user_avatar_path', _image!.path);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранен!')),
    );
    _toggleEditing();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileAvatar(
                image: _image,
                isEditing: _isEditing,
                onAddImagePressed: _pickImage,
              ),
              
              const SizedBox(height: 32),
              
              // --- Условное отображение полей ---
              if (_isEditing) ...[
                TextField(
                  controller: _nameController,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    border: const OutlineInputBorder(),
                    filled: !_isEditing,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _aboutController,
                  maxLines: 3,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    labelText: 'О себе',
                    border: const OutlineInputBorder(),
                    filled: !_isEditing,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ] else ...[
                // Отображаем имя и "О себе" как обычный текст
                Text(
                  _nameController.text,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _aboutController.text,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: 32),

              // --- Кнопка "Редактировать профиль" или "Отменить" ---
              TextButton(
                onPressed: _toggleEditing,
                child: Text(
                  _isEditing ? 'Отменить' : 'Редактировать профиль',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 16),
              
              // --- Кнопка "Сохранить" ---
              if (_isEditing)
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Сохранить'),
                ),
              
              if (_isEditing)
                const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () {},
                child: const Text('Служба поддержки'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Выйти из аккаунта'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}