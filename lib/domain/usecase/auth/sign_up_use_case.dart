import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';

class SignUpUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Result<void>> call(
      String email, String password, String nickName) async {
    return ErrorApi.handleAuthError(() async {
      // email과 비밀번호로 새로운 유저 생성
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;

      await user?.updateDisplayName(nickName);

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}
