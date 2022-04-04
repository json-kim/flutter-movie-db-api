class TokenResponse {
  final String? idToken;
  final String accessToken;
  final String? refreshToken;

  TokenResponse({this.idToken, required this.accessToken, this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      idToken: json['idToken'] as String?,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  @override
  String toString() =>
      'TokenResponse(idToken: $idToken, accessToken: $accessToken, refreshToken: $refreshToken)';
}
