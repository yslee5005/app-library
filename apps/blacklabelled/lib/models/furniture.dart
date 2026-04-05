import 'package:freezed_annotation/freezed_annotation.dart';

part 'furniture.freezed.dart';
part 'furniture.g.dart';

@freezed
class Furniture with _$Furniture {
  const factory Furniture({
    required String id,
    required String title,
    required String category,
    required String description,
    required List<String> images,
  }) = _Furniture;

  factory Furniture.fromJson(Map<String, dynamic> json) =>
      _$FurnitureFromJson(json);
}
