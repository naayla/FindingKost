import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_kelompok/models/kost_model.dart';
import 'package:tugas_kelompok/providers/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('toggleFavorite updates favorites list', () async {
    final appState = AppState();
    final testKost = Kost(
      id: 'kost-42',
      categoryId: 'cat_1',
      title: 'Test Kost',
      location: 'Medan',
      price: 'Rp 500.000',
      rating: 4.5,
      imageUrl: '',
    );

    expect(appState.isFavorite(testKost), false);
    appState.toggleFavorite(testKost);
    expect(appState.isFavorite(testKost), true);
  });
}
