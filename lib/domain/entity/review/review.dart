import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String author,
    @JsonKey(name: 'author_details') required String userName,
    required String content,
    required String createdAt,
    required String id,
    required String updatedAt,
    required String url,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
