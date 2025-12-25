import 'package:flutter/material.dart';

class AvatarInitial extends StatelessWidget {
  final String name;
  final double radius;

  const AvatarInitial({super.key, required this.name, this.radius = 18});

  String get initial => name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade100,
      child: Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
