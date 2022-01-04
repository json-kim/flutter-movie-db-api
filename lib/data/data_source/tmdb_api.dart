import 'package:http/http.dart' as http;
import 'package:movie_search/core/resources/result.dart';

class TMDBApi {
  Future<Result<String>> fetch(String url) async {
    try {
      final uri = Uri.parse(url);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // 성공
        return Result.success(response.body);
      } else {
        return const Result.error('api 에러');
      }
    } catch (e) {
      return const Result.error('네트워크 통신 에러');
    }
  }
}

// TMDB Api는 무슨일이 있어도 url받아 요청하고 결과를 문자열로 돌려주는 역할
// TMDB Api 서버와 네트워크 통신만 하는 역할
