import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/person/person.dart';

part 'person_detail_event.freezed.dart';

@freezed
class PersonDetailEvent with _$PersonDetailEvent {
  const factory PersonDetailEvent.loadPerson(int personId) = LoadPersonDetail;
  const factory PersonDetailEvent.savePerson(Person person) = SavePerson;
}
