import 'dart:ui' show Color;

class QTPassage {
  final String id;
  final String reference;
  final String locale;
  final String text;
  final String topic;
  final String theme;
  final String batchSlot;
  final String icon;
  final String colorHex;
  final DateTime date;
  final bool isCompleted;

  const QTPassage({
    required this.id,
    required this.reference,
    this.locale = 'en',
    required this.text,
    this.topic = '',
    this.theme = '',
    this.batchSlot = 'morning',
    required this.icon,
    required this.colorHex,
    required this.date,
    this.isCompleted = false,
  });

  factory QTPassage.fromJson(Map<String, dynamic> json) {
    return QTPassage(
      id: json['id'] as String,
      reference: json['reference'] as String,
      locale: json['locale'] as String? ?? 'en',
      text: json['text'] as String,
      topic: json['topic'] as String? ?? '',
      theme: json['theme'] as String? ?? '',
      batchSlot: json['batch_slot'] as String? ?? 'morning',
      icon: json['icon'] as String,
      colorHex: json['color_hex'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
}
