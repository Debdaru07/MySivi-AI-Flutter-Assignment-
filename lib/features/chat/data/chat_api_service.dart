import 'dart:convert';
import 'dart:developer' as console;
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class ChatApiService {
  final _random = Random();

  Future<String> fetchMessage() async {
    try {
      console.log('url - ${ApiConstants.comments}');

      final res = await http.get(Uri.parse(ApiConstants.comments));

      if (res.statusCode != 200) {
        throw Exception('Network error');
      }

      final data = jsonDecode(res.body);
      console.log('data - $data');

      if (data is Map && data['comments'] is List) {
        final List comments = data['comments'];

        if (comments.isNotEmpty) {
          final randomIndex = _random.nextInt(comments.length);
          return comments[randomIndex]['body'] ?? '';
        }
      }

      throw Exception('Invalid API response');
    } catch (exc) {
      console.log('exception - $exc');
      throw Exception('Invalid API response');
    }
  }
}
