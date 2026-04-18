import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/qt_passage.dart';

void main() {
  group('QTPassage', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'qt-1',
        'reference': 'Psalm 23:1-6',
        'locale': 'en',
        'text': 'The Lord is my shepherd.',
        'topic': 'Hope',
        'theme': 'hope',
        'batch_slot': 'morning',
        'icon': '🌿',
        'color_hex': '#B2DFDB',
        'date': '2026-04-06',
        'is_completed': false,
      };

      final passage = QTPassage.fromJson(json);

      expect(passage.id, 'qt-1');
      expect(passage.reference, 'Psalm 23:1-6');
      expect(passage.locale, 'en');
      expect(passage.text, 'The Lord is my shepherd.');
      expect(passage.topic, 'Hope');
      expect(passage.theme, 'hope');
      expect(passage.batchSlot, 'morning');
      expect(passage.icon, '🌿');
      expect(passage.colorHex, '#B2DFDB');
      expect(passage.date, DateTime.parse('2026-04-06'));
      expect(passage.isCompleted, false);
    });

    test('isCompleted defaults to false', () {
      final json = {
        'id': 'qt-2',
        'reference': 'Phil 4:6',
        'locale': 'ko',
        'text': '염려하지 말라.',
        'icon': '🌸',
        'color_hex': '#FFB7C5',
        'date': '2026-04-06',
      };

      final passage = QTPassage.fromJson(json);
      expect(passage.isCompleted, false);
    });

    test('text is a direct field (no locale method needed)', () {
      final passage = QTPassage(
        id: 'qt-3',
        reference: 'Ref',
        locale: 'en',
        text: 'English text',
        icon: '🌿',
        colorHex: '#B2DFDB',
        date: DateTime(2026, 4, 6),
      );

      expect(passage.text, 'English text');
      expect(passage.locale, 'en');
    });

    test('color getter parses hex color', () {
      final passage = QTPassage(
        id: 'qt-4',
        reference: 'Ref',
        text: 'Text',
        icon: '🌸',
        colorHex: '#FFB7C5',
        date: DateTime(2026, 4, 6),
      );

      expect(passage.color, const Color(0xFFFFB7C5));
    });
  });
}
