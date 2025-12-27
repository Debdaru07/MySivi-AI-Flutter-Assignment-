class UserModel {
  final String id;
  final String name;
  final String? avatarUrl;

  final bool isOnline;
  final DateTime lastSeen;
  final DateTime? lastReadAt;
  final DateTime? lastMessageAt;

  const UserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isOnline = false,
    required this.lastSeen,
    this.lastReadAt,
    this.lastMessageAt,
  });

  /// Avatar fallback
  String get initial => name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  /// Unread message indicator (used in user list UI)
  bool get hasUnread =>
      lastMessageAt != null &&
      (lastReadAt == null || lastMessageAt!.isAfter(lastReadAt!));

  UserModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? lastReadAt,
    DateTime? lastMessageAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  /// (Used later for Hive / JSON)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarUrl': avatarUrl,
    'isOnline': isOnline,
    'lastSeen': lastSeen.toIso8601String(),
    'lastReadAt': lastReadAt?.toIso8601String(),
    'lastMessageAt': lastMessageAt?.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen']),
      lastReadAt:
          json['lastReadAt'] != null
              ? DateTime.parse(json['lastReadAt'])
              : null,
      lastMessageAt:
          json['lastMessageAt'] != null
              ? DateTime.parse(json['lastMessageAt'])
              : null,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name)';
}
