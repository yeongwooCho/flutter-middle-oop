import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴 (현 데이터를 유지한채 새로고침)
    // false - 새로고침 (현재 상태를 덮어씌움)

    bool forceRefetch = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
  }) async {
    // state 의 상태 5가지
    // 1) CursorPagination State - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading State - 데이터가 로딩중인 상태 (현재 캐시 없음)
    // 3) CursorPaginationError State - 에러가 있는 상태
    // 4) CursorPaginationRefetching State - 첫번째 페이지부터 다시 데이터를 가져올 때
    // 5) CursorPaginationFetchMore State - 추가 데이터를 paginate paginate 해오라는 요청을 받았을 때

    // final resp = await repository.paginate();
    // state = resp;

    // 바로 반환하는 상황
    // 1) hasMore == false (기존 상황에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    // 2) 로딩 중 -> fetchMore == true
    //    로딩 중 -> fetchMore == false (새로고침의 의도가 있을 수 있다.)

    // 1) hasMore == false (기존 상황에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    if (state is CursorPagination && !forceRefetch) {
      // 데이터가 이미 있고 강제 로딩이 아닌 경우
      final pState = state as CursorPagination; // 이게 아닌 상황은 없다. 조건 체크 함.
      // 파스트 스테이트?
      if (!pState.meta.hasMore) {
        return;
      }
    }

    // 2) 로딩 중 -> fetchMore == true
    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationFetchingMore;

    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }
  }
}
