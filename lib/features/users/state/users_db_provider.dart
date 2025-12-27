import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/users_db_service.dart';

final usersDbProvider = Provider<UsersDbService>((ref) {
  final db = UsersDbService();
  ref.onDispose(() async {
    // optional cleanup later
  });
  return db;
});
