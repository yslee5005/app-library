import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrap.freezed.dart';
part 'scrap.g.dart';

@freezed
class Scrap with _$Scrap {
  const factory Scrap({
    required String contentType,
    required String contentId,
    required DateTime createdAt,
  }) = _Scrap;

  factory Scrap.fromJson(Map<String, dynamic> json) => _$ScrapFromJson(json);
}
