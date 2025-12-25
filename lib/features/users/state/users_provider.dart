import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final usersProvider = StateNotifierProvider<UsersNotifier, List<UserModel>>(
  (ref) => UsersNotifier(),
);

class UsersNotifier extends StateNotifier<List<UserModel>> {
  UsersNotifier() : super([]);

  void addUser(String name) {
    state = [
      ...state,
      UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
      ),
    ];
  }
}
