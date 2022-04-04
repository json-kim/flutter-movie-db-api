class KakaoConstants {
  static const String scheme = 'https';
  static const String kauth = 'kauth.kakao.com';
  static const String kapi = 'kapi.kakao.com';
  static const String contentType = 'application/x-www-form-urlencoded';
  static const String autorization = 'Authorization';
  static const String bearer = 'Bearer';

  static const String clientId = 'client_id';
  static const String responseType = 'response_type';
  static const String redirectUri = 'redirect_uri';
  static const String grantType = 'grant_type';
  static const String code = 'code';
  static const String authorizationCode = 'authorization_code';
  static const String refreshToken = 'refresh_token';

  static const String tokenPath = '/oauth/token';
  static const String authCodePath = '/oauth/authorize';
  static const String userPath = '/v2/user/me';
  static const String logoutPath = '/v1/user/logout';
}
