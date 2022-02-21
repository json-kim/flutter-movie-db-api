import 'package:movie_search/domain/usecase/search_history/delete_all_histories_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/delete_search_history_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/get_search_histories_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/save_search_history_use_case.dart';

class SearchHistoryUseCases {
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase;
  final GetSearchHistoriesUseCase getSearchHistoriesUseCase;
  final DeleteSearchHistoryUseCase deleteSearchHistoryUseCase;
  final DeleteAllHistoryUseCase deleteAllHistoryUseCase;

  SearchHistoryUseCases({
    required this.saveSearchHistoryUseCase,
    required this.getSearchHistoriesUseCase,
    required this.deleteSearchHistoryUseCase,
    required this.deleteAllHistoryUseCase,
  });
}
