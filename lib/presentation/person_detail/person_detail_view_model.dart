import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/cast/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/presentation/person_detail/person_detail_event.dart';
import 'package:movie_search/presentation/person_detail/person_detail_state.dart';

class PersonDetailViewModel with ChangeNotifier {
  final GetPersonDetailUseCase _getPersonDetailUseCase;
  final GetCastWithPersonUseCase _getCastWithPersonUseCase;
  final FindBookmarkDataUseCase<Person> _findBookmarkDataUseCase;
  final SaveBookmarkDataUseCase<Person> _saveBookmarkDataUseCase;
  final DeleteBookmarkDataUseCase<Person> _deleteBookmarkDataUseCase;
  final int personId;

  PersonDetailState _state = PersonDetailState();
  PersonDetailState get state => _state;

  PersonDetailViewModel(
    this.personId,
    this._getPersonDetailUseCase,
    this._getCastWithPersonUseCase,
    this._findBookmarkDataUseCase,
    this._saveBookmarkDataUseCase,
    this._deleteBookmarkDataUseCase,
  ) {
    _loadPerson();
    _loadBookmarkData();
  }

  Future<void> onEvent(PersonDetailEvent event) {
    return event.when(loadPerson: _loadPerson, toggleBookmark: _toggleBookmark);
  }

  Future<void> _toggleBookmark() async {
    _state = _state.copyWith(isToggle: true);
    notifyListeners();

    final person = _state.person;

    if (person == null) {
      return;
    }

    final int resultVal;
    if (!_state.isBookmarked) {
      resultVal = await _saveBookmarkData(person);
      await _loadBookmarkData();
    } else {
      resultVal = await _deleteBookmarkData(person.id);
      await _loadBookmarkData();
    }
    if (resultVal != -1) {
    } else {
      // TODO: 북마크 동작 실패
      debugPrint('실패');
    }

    await _loadBookmarkData();
    _state = _state.copyWith(isToggle: false);
    notifyListeners();
  }

  Future<int> _saveBookmarkData(Person person) async {
    final result = await _saveBookmarkDataUseCase(person);

    return result.when(
      success: (id) => id,
      error: (message) {
        debugPrint(message);
        return -1;
      },
    );
  }

  Future<int> _deleteBookmarkData(int id) async {
    final result = await _deleteBookmarkDataUseCase(id);

    return result.when(success: (count) {
      return count;
    }, error: (message) {
      debugPrint(message);
      return -1;
    });
  }

  Future<void> _loadBookmarkData() async {
    final result = await _findBookmarkDataUseCase(personId);

    final isBookmarked = result.when(success: (person) {
      return person.id == personId;
    }, error: (message) {
      return false;
    });

    _state = _state.copyWith(isBookmarked: isBookmarked);

    notifyListeners();
  }

  Future<void> _loadPerson() async {
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
}
