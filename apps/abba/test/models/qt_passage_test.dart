import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/qt_passage.dart';

void main() {
  group('QTPassage', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'qt-1',
        'reference': 'Psalm 23:1-6',
        'text_en': 'The Lord is my shepherd.',
        'text_ko': '여호와는 나의 목자시니.',
        'icon': '🌿',
        'color_hex': '#B2DFDB',
        'date': '2026-04-06',
        'is_completed': false,
      };

      final passage = QTPassage.fromJson(json);

      expect(passage.id, 'qt-1');
      expect(passage.reference, 'Psalm 23:1-6');
      expect(passage.textEn, 'The Lord is my shepherd.');
      expect(passage.textKo, '여호와는 나의 목자시니.');
      expect(passage.icon, '🌿');
      expect(passage.colorHex, '#B2DFDB');
      expect(passage.date, DateTime.parse('2026-04-06'));
      expect(passage.isCompleted, false);
    });

    test('isCompleted defaults to false', () {
      final json = {
        'id': 'qt-2',
        'reference': 'Phil 4:6',
        'text_en': 'Do not be anxious.',
        'text_ko': '염려하지 말라.',
        'icon': '🌸',
        'color_hex': '#FFB7C5',
        'date': '2026-04-06',
      };

      final passage = QTPassage.fromJson(json);
      expect(passage.isCompleted, false);
    });

    test('text returns locale-based content', () {
      final passage = QTPassage(
        id: 'qt-3',
        reference: 'Ref',
        textEn: 'English text',
        textKo: '한국어 텍스트',
        icon: '🌿',
        colorHex: '#B2DFDB',
        date: DateTime(2026, 4, 6),
      );

      expect(passage.text('en'), 'English text');
      expect(passage.text('ko'), '한국어 텍스트');
      expect(passage.text('ja'), 'English text'); // fallback
    });

    test('color getter parses hex color', () {
      final passage = QTPassage(
        id: 'qt-4',
        reference: 'Ref',
        textEn: 'Text',
        textKo: '텍스트',
        icon: '🌸',
        colorHex: '#FFB7C5',
        date: DateTime(2026, 4, 6),
      );

      expect(passage.color, const Color(0xFFFFB7C5));
    });
  });
}
