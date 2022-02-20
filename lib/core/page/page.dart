class Page<T> {
  final int currentPage;
  final int lastPage;
  final List<T> items;

  bool get isLastPage => currentPage == lastPage;

  Page({
    required this.currentPage,
    required this.lastPage,
    required this.items,
  });
}
