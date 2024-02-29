import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/model/pagination_params.dart';
import 'package:code_factory_middle/common/provider/pagination_provider.dart';
import 'package:code_factory_middle/restaurant/model/restaurant_model.dart';
import 'package:code_factory_middle/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 만약 데이터가 아직 하나도 없는 상태라면 (state가 CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐때 그냥 리턴, 서버에서 문제가 생긴 것이다.
    if (state is! CursorPagination) {
      return;
    }

    // 여기서부터 진짜 로직이다. CursorPagination임이 확실하며 데이터를 받아왔다.
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // pState에 있는 데이터 중 id 에 해당하는 값을 찾아서 resp로 대체해야 한다.
    // 첫 요청이면 pState에 들어있는 값은 RestaurantModel의 형태이기 때문이다.
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? resp : e)
          .toList(),
    );
    // 내가 요청을 한 데이터만 RestaurantModel에서 RestaurantDetail로 변경이 된다.
  }
}
