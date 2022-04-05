import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:movie_search/service/kakao/kakao_exception.dart';
import 'package:movie_search/service/naver/naver_exception.dart';

import '../result/result.dart';
import 'auth_exception.dart';
import 'remote_api_exception.dart';

/// 유스케이스 단에서 에러 핸들링 메서드
class ErrorApi {
  static Future<Result<T>> handleAuthError<T>(
      Future<Result<T>> Function() requestFunction, String prefix,
      {Logger? logger}) async {
    logger = Logger();
    try {
      return await requestFunction();
    } on Exception catch (e) {
      if (e is KakaoTokenException || e is NaverTokenException) {
        // 토큰 만료시 로그아웃 처리
        await FirebaseAuth.instance.signOut();
      }
      logger.e('${e.runtimeType}: 에러 발생', e);
      return Result.error(e.toString());
    } catch (e) {
      logger.e('$prefix : ${e.runtimeType}: 에러 발생, $e', e);
      return Result.error('Auth 에러 발생');
    }
  }

  /// 파이어베이스 api 사용시 발생하는 에러 핸들러
  static Future<Result<T>> handleRemoteApiError<T>(
      Future<Result<T>> Function() requestFunction,
      Logger logger,
      String prefix) async {
    try {
      return await requestFunction();
    } on FirebaseException catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error(e.toString());
    } on RemoteApiException catch (e) {
      logger.e('$prefix: ${e.runtimeType}\n ${e.message}\n ', e);
      return Result.error(e.toString());
    } on AuthException catch (e) {
      logger.e('$prefix: ${e.message} \n ${e.runtimeType} \n', e);
      return Result.error(e.toString());
    } on Exception catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error(e.toString());
    } catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error('Unknow Exception');
    }
  }
}