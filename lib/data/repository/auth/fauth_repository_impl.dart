import 'package:movie_search/data/data_source/remote/firebase/firebase_auth_remote_data_source.dart';
import 'package:movie_search/domain/model/auth/user_response.dart';
import 'package:movie_search/domain/repository/fauth_repository.dart';

class FAuthRepositoryImpl implements FAuthRepository {
  final FirebaseAuthRemoteDataSource _firebaseAuthRemoteDataSource;

  FAuthRepositoryImpl(this._firebaseAuthRemoteDataSource);

  @override
  Future<String> issueCustomToken(UserResponse userResponse) async {
    return await _firebaseAuthRemoteDataSource.requestCustomToken(userResponse);
  }
}
