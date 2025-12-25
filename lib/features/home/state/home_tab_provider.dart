import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_tab.dart';

final homeTabProvider = StateProvider<HomeTab>((ref) => HomeTab.users);
