class PaginationController {
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  void reset() {
    page = 1;
    hasMore = true;
  }

  void nextPage() {
    page++;
  }
}
