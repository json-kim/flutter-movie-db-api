import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';

class FindPWUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<void>> call(String email) async {
    return ErrorApi.handleAuthError(() async {
      await _auth.sendPasswordResetEmail(email: email);

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}
