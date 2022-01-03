import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit.freezed.dart';
part 'credit.g.dart';

@freezed
class Credit with _$Credit {
  const factory Credit({
    required bool adult,
    required int gender,
    required int id,
    required String knownForDepartment,
    required String name,
    required String originalName,
    required double popularity,
    required String profilePath,
    required int castId,
    required String character,
    required String creditId,
    required int order,
  }) = _Credit;

  factory Credit.fromJson(Map<String, dynamic> json) => _$CreditFromJson(json);
}
