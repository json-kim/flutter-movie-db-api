import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';
part 'video.g.dart';

@freezed
class Video with _$Video {
  const factory Video({
    required String iso_639_1,
    required String iso_3166_1,
    required String name,
    required String key,
    required String site,
    required int size,
    required String type,
    required bool official,
    required String publishedAt,
    required String id,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}
