import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/features/users/state/users_provider.dart';
import '../../../../lib/features/users/data/users_api_service.dart';
import '../../../../lib/features/users/data/users_db_service.dart';
import '../../../../lib/features/users/state/users_db_provider.dart';
import '../../../../lib/features/users/models/user_model.dart';

class MockUsersApiService extends Mock implements UsersApiService {}

class MockUsersDbService extends Mock implements UsersDbService {}

void main() {
  late MockUsersApiService api;
  late MockUsersDbService db;
  late ProviderContainer container;

  final now = DateTime.now();

  final user = UserModel(
    id: 'u1',
    name: 'Alice',
    isOnline: true,
    lastSeen: now,
  );

  setUp(() {
    api = MockUsersApiService();
    db = MockUsersDbService();

    when(() => db.init()).thenAnswer((_) async {});
    when(() => db.getUsers()).thenAnswer((_) async => []);
    when(() => db.saveUser(any())).thenAnswer((_) async {});
    when(() => db.deleteUser(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        usersApiProvider.overrideWithValue(api),
        usersDbProvider.overrideWithValue(db),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state loads users from DB', () async {
    when(() => db.getUsers()).thenAnswer((_) async => [user]);

    // allow async init to complete
    await Future<void>.delayed(Duration.zero);

    final state = container.read(usersProvider);

    expect(state.length, 1);
    expect(state.first.name, 'Alice');
  });

  test('addRandomUser fetches from API and saves to DB', () async {
    when(() => api.fetchRandomUser()).thenAnswer((_) async => user);

    final notifier = container.read(usersProvider.notifier);
    await notifier.addRandomUser();

    final users = container.read(usersProvider);

    expect(users.length, 1);
    expect(users.first.id, 'u1');

    verify(() => db.saveUser(user)).called(1);
  });

  test('API failure does not update state', () async {
    when(() => api.fetchRandomUser()).thenThrow(Exception('API error'));

    final notifier = container.read(usersProvider.notifier);
    await notifier.addRandomUser();

    final users = container.read(usersProvider);

    expect(users, isEmpty);
  });
}
