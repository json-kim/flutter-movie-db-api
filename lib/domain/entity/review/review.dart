import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String author,
    required String content,
    @JsonKey(name: 'created_at') required String createdAt,
    required String id,
    @JsonKey(name: 'updated_at') required String updatedAt,
    required String url,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
