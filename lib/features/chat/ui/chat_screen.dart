import 'package:flutter/material.dart';
import '../../users/models/user_model.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  final UserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: const Center(child: Text('Chat Screen')),
    );
  }
}
