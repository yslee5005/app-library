import 'package:freezed_annotation/freezed_annotation.dart';

part 'magazine.freezed.dart';
part 'magazine.g.dart';

@freezed
class Magazine with _$Magazine {
  const factory Magazine({
    required String id,
    required String title,
    required String summary,
    required String thumbnail,
    required String date,
  }) = _Magazine;

  factory Magazine.fromJson(Map<String, dynamic> json) =>
      _$MagazineFromJson(json);
}
