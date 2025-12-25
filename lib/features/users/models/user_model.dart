class UserModel {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  String get initial => name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  UserModel copyWith({String? id, String? name}) {
    return UserModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name)';
}
