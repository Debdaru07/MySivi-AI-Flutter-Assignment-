import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysivi_ai_assessment/features/users/models/user_model.dart';

import '../data/users_api_service.dart';
import '../data/users_db_service.dart';
import 'users_db_provider.dart';

final usersProvider = StateNotifierProvider<UsersNotifier, List<UserModel>>((
  ref,
) {
  final api = UsersApiService();
  final db = ref.read(usersDbProvider);

  return UsersNotifier(api, db);
});

class UsersNotifier extends StateNotifier<List<UserModel>> {
  final UsersApiService api;
  final UsersDbService db;

  UsersNotifier(this.api, this.db) : super([]) {
    _init();
  }

  Future<void> _init() async {
    await db.init();
    final storedUsers = await db.getUsers();
    state = storedUsers;
  }

  Future<void> addRandomUser() async {
    final user = await api.fetchRandomUser();
    state = [...state, user];
    await db.saveUser(user);
  }

  Future<void> updateUser(UserModel updated) async {
    state = [
      for (final u in state)
        if (u.id == updated.id) updated else u,
    ];
    await db.saveUser(updated);
  }

  Future<void> deleteUser(String userId) async {
    state = state.where((u) => u.id != userId).toList();
    await db.deleteUser(userId);
  }
}
