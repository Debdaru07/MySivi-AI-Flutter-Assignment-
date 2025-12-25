import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_history_model.dart';

final chatHistoryProvider = Provider<List<ChatHistoryModel>>((ref) => []);
