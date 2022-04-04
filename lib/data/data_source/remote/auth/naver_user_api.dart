import 'package:dio/dio.dart';
import 'package:movie_search/domain/model/auth/user_response.dart';
import 'package:movie_search/domain/usecase/auth/constants.dart';
import 'package:movie_search/service/naver/naver_api_factory.dart';
import 'package:movie_search/service/naver/naver_constants.dart';
import 'package:movie_search/service/naver/naver_exception_handler.dart';

class NaverUserApi {
  final Dio _apiDio;

  NaverUserApi({Dio? apiDio}) : _apiDio = apiDio ?? NaverApiFactory.tokenApi;

  static final instance = NaverUserApi();

  // 네이버 로그아웃 (토큰 서버에서 만료)
  Future<void> signOut() async {
    return NaverExceptionHandler.handleApiError(() async {
      // 네이버에서는 로그아웃을 지원하지 않음
      // 네이버 토큰 삭제하기
    });
  }

  // 유저 정보 가져오기
  Future<UserResponse> getUserData() async {
    return NaverExceptionHandler.handleApiError(() async {
      final response = await _apiDio.get(NaverConstants.userPath);

      final userMap = response.data['response'];

      final id = userMap['id'] as String;
      final userName = userMap['name'] as String;
      final email = userMap['email'] as String;
      final photoUrl = userMap['profile_image'] as String;

      final userResponse = UserResponse(
        uid: id,
        email: email,
        userName: userName,
        photoUrl: photoUrl,
        loginMethod: LoginMethod.naver,
      );

      return userResponse;
    });
  }
}
