import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/use_case.dart';
import 'package:movie_search/presentation/person_detail/person_detail_event.dart';
import 'package:movie_search/presentation/person_detail/person_detail_state.dart';

class PersonDetailViewModel with ChangeNotifier {
  final UseCase<Person, Param> _getPersonDetailUseCase;
  final UseCase<List<Cast>, Param> _getCastWithPersonUseCase;
  final int personId;

  PersonDetailState _state = PersonDetailState(casts: []);
  PersonDetailState get state => _state;

  PersonDetailViewModel(
    this.personId,
    this._getPersonDetailUseCase,
    this._getCastWithPersonUseCase,
  ) {
    _loadPerson(personId);
  }

  Future<void> onEvent(PersonDetailEvent event) {
    return event.when(loadPerson: _loadPerson, savePerson: _savePerson);
  }

  Future<void> _loadPerson(int personId) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _getPersonDetailUseCase(Param.personDetail(personId));

    result.when(
        success: (person) {
          _state = _state.copyWith(person: person);
        },
        error: (message) {});
    await _loadCasts(personId);

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _loadCasts(int personId) async {
    final result =
        await _getCastWithPersonUseCase(Param.castWithPerson(personId));

    result.when(
        success: (casts) {
          _state = _state.copyWith(casts: casts);
        },
        error: (message) {});
  }

  Future<void> _savePerson(Person person) async {
    final result =
        await _getCastWithPersonUseCase(Param.personDetail(personId));

    result.when(success: (_) {}, error: (message) {});
  }
}
