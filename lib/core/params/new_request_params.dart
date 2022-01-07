enum Source {
  tmdbApi,
  sqflite,
}

abstract class Params<T> {
  T data;

  Params(this.data);

  T Function(T data);
}
// abstract class Params {
//   const factory Params.
// }
//
//
// abstract class Params {}
//
// class RequestParams implements Params {
//   final Source source;
//   final String apiKey;
//   final String language;
//   final String pathParams;
//
//   RequestParams(this.source, this.apiKey, this.language, this.pathParams);
// }
