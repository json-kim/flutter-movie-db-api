import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/model/review/review.dart';

class BackupData {
  DateTime uploadDate;
  List<Movie> movies;
  List<Person> persons;
  List<Review> reviews;

  BackupData({
    required this.uploadDate,
    required this.movies,
    required this.persons,
    required this.reviews,
  });

  factory BackupData.fromJson(Map<String, dynamic> json) {
    List jsonMovies = json['movies'];
    List jsonPersons = json['persons'];
    List jsonReviews = json['reviews'];
    List<Movie> movies =
        jsonMovies.map((json) => Movie.fromJson(json)).toList();
    List<Person> persons =
        jsonPersons.map((json) => Person.fromJson(json)).toList();
    List<Review> reviews =
        jsonReviews.map((json) => Review.fromJson(json)).toList();

    return BackupData(
      uploadDate: DateTime.parse(json['uploadDate']),
      movies: movies,
      persons: persons,
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonMovies =
        movies.map((movie) => movie.toJson()).toList();
    List<Map<String, dynamic>> jsonPersons =
        persons.map((person) => person.toJson()).toList();
    List<Map<String, dynamic>> jsonReviews =
        reviews.map((review) => review.toJson()).toList();

    return {
      'uploadDate': uploadDate.toIso8601String(),
      'movies': jsonMovies,
      'persons': jsonPersons,
      'reviews': jsonReviews,
    };
  }
}
