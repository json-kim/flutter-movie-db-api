import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit.freezed.dart';
part 'credit.g.dart';

@freezed
class Credit with _$Credit {
  const factory Credit({
    required bool adult,
    required int? gender,
    required int id,
    @JsonKey(name: 'known_for_department') required String knownForDepartment,
    required String name,
    @JsonKey(name: 'original_name') required String originalName,
    required double popularity,
    @JsonKey(name: 'profile_path') required String? profilePath,
    @JsonKey(name: 'cast_id') required int castId,
    required String character,
    @JsonKey(name: 'credit_id') required String creditId,
    required int order,
  }) = _Credit;

  factory Credit.fromJson(Map<String, dynamic> json) => _$CreditFromJson(json);
}
