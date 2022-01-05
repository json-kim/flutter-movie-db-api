import 'package:movie_search/domain/repository/movie_data_repository.dart';

abstract class UseCase<T, P> {
  final MovieDataRepository repository;
  UseCase(this.repository);

  Future<T> call(P params);
}

// 유스케이스 목록
// 1. 장르 가져오기 ㅇ
// 2. 장르로 영화 가져오기 ㅇ
// 3. 키워드로 영화 가져오기 ㅇ
// 4. 쿼리로 영화 가져오기 ㅇ
// 5. 인기 영화 가져오기 ㅇ
// 6. 현재 상영중 영화 가져오기 ㅇ
// 7. 영화로 키워드 가져오기 ㅇ
// 8. 영화로 리뷰 가져오기 ㅇ
// 9. 영화로 비디오 가져오기 ㅇ
// 10. 영화로 크레딧 가져오기 ㅇ
// 11. 영화로 비슷한 영화 가져오기 ㅇ
// 12. 영화로 추천 영화 가져오기 ㅇ
// 13. 인물 상세정보 가져오기 ㅇ

// 유스케이스에서는 페이지와 같이 요청에 맞는 영화정보를 전체적으로 관리 하는 로직
