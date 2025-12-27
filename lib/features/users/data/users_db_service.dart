import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UsersDbService {
  static const _boxName = 'users_box';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<List<UserModel>> getUsers() async {
    return _box.values
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveUser(UserModel user) async {
    await _box.put(user.id, user.toJson());
  }

  Future<void> saveUsers(List<UserModel> users) async {
    for (final user in users) {
      await saveUser(user);
    }
  }

  Future<void> deleteUser(String userId) async {
    await _box.delete(userId);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
