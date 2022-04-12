import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';

class EmailLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<void>> call(String email, String password) async {
    return ErrorApi.handleAuthError(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}
