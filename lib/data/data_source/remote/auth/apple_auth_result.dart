import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthResult {
  final AuthorizationCredentialAppleID account;
  final String rawNonce;

  AppleAuthResult(
    this.account,
    this.rawNonce,
  );
}
