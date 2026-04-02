import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/services/pet_storage_service.dart';

void main() {
  group('PetStorageService', () {
    group('dateString', () {
      test('formats date correctly', () {
        expect(
          PetStorageService.dateString(DateTime(2024, 3, 5)),
          '2024-03-05',
        );
      });

      test('pads single-digit months and days', () {
        expect(
          PetStorageService.dateString(DateTime(2024, 1, 1)),
          '2024-01-01',
        );
      });

      test('handles December 31', () {
        expect(
          PetStorageService.dateString(DateTime(2024, 12, 31)),
          '2024-12-31',
        );
      });
    });

    // Note: Full storage tests require SharedPreferences mock (TestWidgetsFlutterBinding)
    // which is tested in flow tests. Here we test the pure helper functions.
  });
}
