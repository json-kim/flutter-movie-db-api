import 'package:http/http.dart' as http;
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';

class MovieRemoteDataSource {
  Future<Result<String>> fetch(Param param, {String language = 'ko-KR'}) async {
    try {
      final uri = Uri.parse(paramToUrl(param, language));

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // 성공
        return Result.success(response.body);
      } else {
        return Result.error('$runtimeType : 네트워크 에러 ${response.statusCode}');
      }
    } catch (e) {
      return Result.error('$runtimeType : 네트워크 에러');
    }
  }
}

// TMDB Api는 무슨일이 있어도 url받아 요청하고 결과를 문자열로 돌려주는 역할
// TMDB Api 서버와 네트워크 통신만 하는 역할
