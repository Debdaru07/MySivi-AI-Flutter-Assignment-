import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class ChatApiService {
  final _random = Random();

  static const _fallbackMessages = [
    'Sounds good!',
    'Interesting 🤔',
    'Got it 👍',
    'Tell me more.',
    'That makes sense.',
    'Okay!',
  ];

  Future<String> fetchMessage() async {
    try {
      final res = await http
          .get(Uri.parse(ApiConstants.comments))
          .timeout(const Duration(seconds: 5));

      if (res.statusCode != 200) {
        throw Exception('Bad response');
      }

      final data = jsonDecode(res.body);

      if (data is Map &&
          data['comments'] is List &&
          data['comments'].isNotEmpty) {
        final comments = data['comments'] as List;
        final randomIndex = _random.nextInt(comments.length);
        return comments[randomIndex]['body'] ?? _randomFallback();
      }
    } catch (_) {
      // 👇 Network / DNS / timeout / parsing fallback
      return _randomFallback();
    }

    return _randomFallback();
  }

  String _randomFallback() {
    return _fallbackMessages[_random.nextInt(_fallbackMessages.length)];
  }
}
