import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class ChatApiService {
  Future<String> fetchMessage() async {
    final res = await http.get(Uri.parse(ApiConstants.randomQuote));
    final data = jsonDecode(res.body);
    return data['content'];
  }
}
