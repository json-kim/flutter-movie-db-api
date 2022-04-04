import 'package:movie_search/domain/model/auth/user_response.dart';

abstract class FAuthRepository {
  Future<String> issueCustomToken(UserResponse userResponse);
}
