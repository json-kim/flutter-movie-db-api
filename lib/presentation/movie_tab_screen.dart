import 'package:flutter/material.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_screen.dart';
import 'package:movie_search/presentation/movie_home/movie_home_screen.dart';
import 'package:movie_search/presentation/movie_soon/movie_soon_screen.dart';

import 'movie_search/movie_search_screen.dart';

class MovieTabScreen extends StatefulWidget {
  const MovieTabScreen({Key? key}) : super(key: key);

  @override
  State<MovieTabScreen> createState() => _MovieTabScreenState();
}

class _MovieTabScreenState extends State<MovieTabScreen> {
  final PageController _pageController = PageController(keepPage: true);
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const MovieHomeScreen(),
    const MovieSearchScreen(),
    const MovieSoonScreen(),
    const MovieBookmarkScreen(),
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
        restorationId: 'dfsfd',
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
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter_rounded), label: '공개 예정'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '마이 노트'),
        ],
      ),
    );
  }
}
