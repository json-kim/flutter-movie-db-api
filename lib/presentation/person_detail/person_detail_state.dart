import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/model/person/person.dart';

part 'person_detail_state.freezed.dart';

@freezed
class PersonDetailState with _$PersonDetailState {
  const factory PersonDetailState({
    Person? person,
    required List<Cast> casts,
  }) = _PersonDetailState;
}
