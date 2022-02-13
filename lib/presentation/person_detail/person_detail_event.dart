import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_detail_event.freezed.dart';

@freezed
class PersonDetailEvent with _$PersonDetailEvent {
  const factory PersonDetailEvent.loadPerson() = LoadPersonDetail;
  const factory PersonDetailEvent.toggleBookmark() = ToggleBookmark;
}
