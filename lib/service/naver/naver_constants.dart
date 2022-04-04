class NaverConstants {
  static const String scheme = 'https';
  static const String nauth = 'nid.naver.com';
  static const String napi = 'openapi.naver.com';
  static const String contentType = 'application/x-www-form-urlencoded';

  static const String authCodePath = '/oauth2.0/authorize';
  static const String tokenPath = '/oauth2.0/token';
  static const String userPath = '/v1/nid/me';

  static const String issueGrantType = 'authorization_code';
  static const String refreshGrantType = 'refresh_token';
  static const String deleteGrantType = 'delete';

  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String responseType = 'response_type';
  static const String clientId = 'client_id';
  static const String redirectUri = 'redirect_uri';
  static const String state = 'state';
  static const String grantType = 'grant_type';
  static const String clientSecret = 'client_secret';
  static const String code = 'code';
  static const String refreshToken = 'refresh_token';
  static const String accessToken = 'access_token';
  static const String serviceProvider = 'service_provider';
}
