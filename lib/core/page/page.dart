/// 페이지네이션 전용 클래스
class Page<T> {
  final int currentPage; // 현재 페이지
  final int lastPage; // 마지막 페이지
  final List<T> items; // 아이템 리스트

  bool get isLastPage => currentPage == lastPage; // 마지막 페이지 체크

  Page({
    required this.currentPage,
    required this.lastPage,
    required this.items,
  });
}
