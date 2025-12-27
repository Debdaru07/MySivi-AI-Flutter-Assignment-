import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lib/features/chat/state/chat_provider.dart';
import '../../lib/features/users/state/users_provider.dart';
import '../../lib/features/users/state/users_db_provider.dart';
import '../../lib/features/chat/data/chat_api_service.dart';
import '../../lib/features/users/data/users_api_service.dart';
import '../../lib/features/chat/ui/chat_screen.dart';
import '../../lib/features/home/ui/home_screen.dart';
import '../../lib/features/users/models/user_model.dart';

class TestApp extends StatelessWidget {
  final List<Override> overrides;

  const TestApp({super.key, required this.overrides});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          if (settings.name == ChatScreen.routeName) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder:
                  (_) => ChatScreen(
                    user: args['user'] as UserModel,
                    readOnly: args['readOnly'] ?? false,
                  ),
            );
          }

          return MaterialPageRoute(builder: (_) => const HomeScreen());
        },
        home: const HomeScreen(),
      ),
    );
  }
}
