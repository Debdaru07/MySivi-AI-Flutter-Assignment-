import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UsersApiService {
  final _uuid = const Uuid();

  Future<UserModel> fetchRandomUser() async {
    final res = await http.get(Uri.parse('https://randomuser.me/api/'));

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch user');
    }

    final data = jsonDecode(res.body)['results'][0];

    return UserModel(
      id: _uuid.v4(),
      name: '${data['name']['first']} ${data['name']['last']}',
      avatarUrl: data['picture']['thumbnail'],
      isOnline: true,
      lastSeen: DateTime.now(),
    );
  }
}
