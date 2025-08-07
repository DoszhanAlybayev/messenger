import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Импортируем пакет
import 'dart:io';

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
    _loadProfileData(); // Загружаем сохраненные данные при инициализации
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  // Метод для загрузки данных из SharedPreferences
  Future<void> _loadProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      // Загружаем имя, если оно есть, иначе используем значение по умолчанию
      _nameController.text = prefs.getString('user_name') ?? 'Иван Иванов';
      
      // Загружаем "о себе", если оно есть
      _aboutController.text = prefs.getString('user_about') ?? 'Привет, я новый пользователь мессенджера!';
      
      // Загружаем путь к аватарке, если он есть
      final String? imagePath = prefs.getString('user_avatar_path');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  // Метод для сохранения данных в SharedPreferences
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
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider
                          : const NetworkImage('https://via.placeholder.com/150'),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: _toggleEditing,
                child: Text(
                  _isEditing ? 'Отменить' : 'Редактировать профиль',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              
              const SizedBox(height: 32),
              
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
              
              const SizedBox(height: 32),

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