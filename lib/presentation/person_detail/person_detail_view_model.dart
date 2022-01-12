import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/use_case.dart';
import 'package:movie_search/presentation/person_detail/person_detail_event.dart';
import 'package:movie_search/presentation/person_detail/person_detail_state.dart';

class PersonDetailViewModel with ChangeNotifier {
  final UseCase<Person, int> _getPersonDetailUseCase;
  final UseCase<List<Cast>, int> _getCastWithPersonUseCase;
  final int personId;

  PersonDetailState _state = PersonDetailState(casts: []);
  PersonDetailState get state => _state;

  PersonDetailViewModel(
    this.personId,
    this._getPersonDetailUseCase,
    this._getCastWithPersonUseCase,
  );

  Future<void> onEvent(PersonDetailEvent event) {
    return event.when(loadPerson: _loadPerson, savePerson: _savePerson);
  }

  Future<void> _loadPerson(int personId) async {
    final result = await _getPersonDetailUseCase(personId);

    result.when(success: (person) {}, error: (message) {});
    await _loadCasts(personId);
    notifyListeners();
  }

  Future<void> _loadCasts(int personId) async {
    final result = await _getCastWithPersonUseCase(personId);

    result.when(success: (casts) {}, error: (message) {});
  }

  Future<void> _savePerson(Person person) async {
    final result = await _getCastWithPersonUseCase(personId);

    result.when(success: (_) {}, error: (message) {});
  }
}
