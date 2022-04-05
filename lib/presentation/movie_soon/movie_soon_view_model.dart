import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/movie/data/movie_upcoming.dart';
import 'package:movie_search/service/hive_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:movie_search/domain/usecase/movie/get_movie_upcoming_use_case.dart';

import 'movie_soon_state.dart';
import 'movie_soon_event.dart';
import 'movie_soon_ui_event.dart';

class MovieSoonViewModel with ChangeNotifier {
  final GetMovieUpcomingUseCase _getMovieUpcomingUseCase;
  final alarmBox = Hive.box('alarm');

  final _pagingController = PagingController<int, Movie>(firstPageKey: 1);
  PagingController<int, Movie> get pagingController => _pagingController;

  final _streamController = StreamController<MovieSoonUiEvent>.broadcast();
  Stream<MovieSoonUiEvent> get uiEventStream => _streamController.stream;

  MovieSoonState _state = MovieSoonState();
  MovieSoonState get state => _state;

  MovieSoonViewModel(
    this._getMovieUpcomingUseCase,
  ) {
    _pagingController.addPageRequestListener(_load);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  bool isAlarmed(int movieId) {
    return alarmBox.containsKey(movieId);
  }

  void onEvent(MovieSoonEvent event) {
    event.when(load: _load, alarm: _alarm, toggleBookmark: _toggleBookmark);
  }

  void _toggleBookmark(Movie movie) {}

  // 뷰모델에서 인피니트 페이지 사용할 때, 로딩중 notifyListener가 실행되서는 안된다.
  // 기능 추가시 보완 필요할 수 있음
  Future<void> _load(int page) async {
    final result =
        await _getMovieUpcomingUseCase(Param.movieUpcoming(page: page));

    result.when(success: (pageResult) {
      final isLastPage = pageResult.isLastPage;
      final newItems = pageResult.items;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, page + 1);
      }
    }, error: (message) {
      _pagingController.error = '불러오기 실패';
    });
  }

  Future<void> _alarm(Movie movie) async {
    _state = _state.copyWith(isLoading: true, isAlarmed: true);
    notifyListeners();

    final alarm = isAlarmed(movie.id);

    if (!alarm) {
      await _setAlarm(movie);
      await alarmBox.put(movie.id, movie.releaseDate);
      _streamController.add(MovieSoonUiEvent.snackBar('알람이 등록되었습니다.'));
    } else {
      await _deleteAlarm(movie);
      await alarmBox.delete(movie.id);
      _streamController.add(MovieSoonUiEvent.snackBar('알람이 해제되었습니다.'));
    }

    _state = _state.copyWith(isLoading: false, isAlarmed: false);
    notifyListeners();
  }

  Future<void> _setAlarm(Movie movie) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    var android = AndroidNotificationDetails('moviereview', movie.title,
        channelDescription: '오늘 공개되었습니다.',
        importance: Importance.max,
        priority: Priority.max);
    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    if (result ?? false) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('id');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // id는 unique해야합니다. int값
        movie.title,
        '${movie.title}가 오늘 공개됩니다.',
        _setNotiTime(DateTime.parse(movie.releaseDate!)),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> _deleteAlarm(Movie movie) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.cancel(movie.id);
  }

  tz.TZDateTime _setNotiTime(DateTime date) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final releaseDate = tz.TZDateTime.from(date, tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, releaseDate.year, releaseDate.month, releaseDate.day, 18, 0);

    return scheduledDate;
  }
}
