import '../../lib/features/users/models/user_model.dart';

UserModel fakeUser({
  String id = 'user-1',
  String name = 'Alice Johnson',
  String? avatarUrl,
}) {
  return UserModel(
    id: id,
    name: name,
    avatarUrl: avatarUrl,
    isOnline: true,
    lastSeen: DateTime.now(),
  );
}
