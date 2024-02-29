import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/model/model_with_id.dart';
import 'package:code_factory_middle/common/model/pagination_params.dart';
import 'package:code_factory_middle/common/repository/pagination/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
> extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴 (현 데이터를 유지한채 새로고침)
    // false - 새로고침 (현재 상태를 덮어씌움)

    bool forceRefetch = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
  }) async {
    try {
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

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount, // 기본 값으로 지정되어 있지만 fetchCount 값이 다르게 요청 될 수 있음.
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황 -> 무조건 데이터를 갖고 있다. 그렇게 되도록 구현할 것이기에.
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        // State를 CursorPagination에서 CursorPaginationFetchingMore 상태로 변경
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        // 중요한 것은 after에 넣으주냐 안 넣어주냐이다.
        paginationParams = paginationParams.copyWith(
          // data 가 null인 상황은 없다. fetchMore==true는 이미 데이터가 있다는 뜻이며 그렇게 구현할 것이기에.
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황, params 변경할 필요 없음.
      else {
        // 만약 데이터가 있는 상황이면 기존 데이터를 보존한 채로 fetch(API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          // 굳이 데이터를 다 날릴 필요가 없다. 유지한 채로 새로운 데이터가 들어올 때 대처 하는게 빨라 보인다.
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황
        else {
          // forceRefetch 또는 CursorPagination가 아닌 경우
          state = CursorPaginationLoading();
        }
      }

      // 최근 데이터
      // resp is CursorPagination<RestaurantModel>
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터 + 최신 데이터
        state = resp.copyWith(
          data: [
            ...pState.data, // 기존 데이터
            ...resp.data, // 최신 데이터
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
