import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_home_event.freezed.dart';

@freezed
class MovieHomeEvent with _$MovieHomeEvent {
  const factory MovieHomeEvent.load() = Load;
  const factory MovieHomeEvent.changeCardPage(int page) = ChangeCardPage;
}
