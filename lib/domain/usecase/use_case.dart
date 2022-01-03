import 'package:movie_search/core/params/request_params.dart';

abstract class UseCase<T, P extends RequestParams> {
  Future<T> call(P param);
}

// 유스케이스 목록
// 1. 장르 가져오기
// 2. 장르로 영화 가져오기
// 3. 키워드로 영화 가져오기
// 4. 쿼리로 영화 가져오기
// 5. 인기 영화 가져오기
// 6. 현재 상영중 영화 가져오기
// 7. 영화로 키워드 가져오기
// 8. 영화로 리뷰 가져오기
// 9. 영화로 비디오 가져오기
// 10. 영화로 크레딧 가져오기
// 11. 인물 상세정보 가져오기
