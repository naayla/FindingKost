import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_kelompok/models/kost_model.dart';
import 'package:tugas_kelompok/models/user_model.dart';
import 'package:tugas_kelompok/models/user_role.dart';
import 'package:tugas_kelompok/providers/app_state.dart';
import 'package:tugas_kelompok/services/firebase_service.dart';

class _FakeFirebaseService extends FirebaseService {
  @override
  Future<List<Kost>> getAllKosts() async => [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saved favorites are restored for the same account', () async {
    final firstState = AppState(firebaseService: _FakeFirebaseService());
    addTearDown(firstState.dispose);

    expect(await firstState.toggleFavorite('kost-42'), isTrue);
    expect(firstState.isFavorite('kost-42'), isTrue);

    final restoredState = AppState(firebaseService: _FakeFirebaseService());
    addTearDown(restoredState.dispose);

    expect(await restoredState.toggleFavorite('kost-42'), isTrue);
    expect(restoredState.isFavorite('kost-42'), isFalse);
  });

  test('favorites are stored separately for different accounts', () async {
    final state = AppState(firebaseService: _FakeFirebaseService());
    addTearDown(state.dispose);
    state.setCurrentUser(
      UserModel(
        id: 'another-seeker',
        name: 'Pencari Lain',
        email: 'other@example.com',
        phone: '',
        role: UserRole.pencariKost,
      ),
    );

    expect(await state.toggleFavorite('kost-42'), isTrue);
    expect(state.favoriteKostIds, ['kost-42']);
  });
}
