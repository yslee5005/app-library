import 'dart:ui' show Color;

class QTPassage {
  final String id;
  final String reference;
  final String textEn;
  final String textKo;
  final String topicEn;
  final String topicKo;
  final String icon;
  final String colorHex;
  final DateTime date;
  final bool isCompleted;

  const QTPassage({
    required this.id,
    required this.reference,
    required this.textEn,
    required this.textKo,
    this.topicEn = '',
    this.topicKo = '',
    required this.icon,
    required this.colorHex,
    required this.date,
    this.isCompleted = false,
  });

  factory QTPassage.fromJson(Map<String, dynamic> json) {
    return QTPassage(
      id: json['id'] as String,
      reference: json['reference'] as String,
      textEn: json['text_en'] as String,
      textKo: json['text_ko'] as String,
      topicEn: json['topic_en'] as String? ?? '',
      topicKo: json['topic_ko'] as String? ?? '',
      icon: json['icon'] as String,
      colorHex: json['color_hex'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  String text(String locale) => locale == 'ko' ? textKo : textEn;
  String topic(String locale) => locale == 'ko' ? topicKo : topicEn;

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
}
