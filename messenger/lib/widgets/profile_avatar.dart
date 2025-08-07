// lib/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileAvatar extends StatelessWidget {
  final File? image;
  final bool isEditing;
  final VoidCallback onAddImagePressed;

  const ProfileAvatar({
    super.key,
    required this.image,
    required this.isEditing,
    required this.onAddImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: image != null
                ? FileImage(image!) as ImageProvider
                : const NetworkImage('https://via.placeholder.com/150'),
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onAddImagePressed,
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
    );
  }
}