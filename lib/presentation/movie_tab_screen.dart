import 'package:flutter/material.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/presentation/movie_home/movie_home_screen.dart';
import 'package:movie_search/presentation/movie_home/movie_home_view_model.dart';
import 'package:movie_search/presentation/movie_search/movie_search_screen.dart';
import 'package:provider/provider.dart';

class MovieTabScreen extends StatefulWidget {
  const MovieTabScreen({Key? key}) : super(key: key);

  @override
  State<MovieTabScreen> createState() => _MovieTabScreenState();
}

class _MovieTabScreenState extends State<MovieTabScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    ChangeNotifierProvider(
      create: (_) => MovieHomeViewModel(tmdbApi: TMDBApi()),
      child: const MovieHomeScreen(),
    ),
    const MovieSearchScreen(),
    Container(),
    Container(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (val) {
          setState(() {
            _pageController.jumpToPage(val);
            _currentPageIndex = val;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: '클립'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
