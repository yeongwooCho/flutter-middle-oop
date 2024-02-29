import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider =
    StateNotifierProvider<RestaurantRatingStateNotifier, CursorPaginationBase>(
        (ref) {
  final repository = ref.watch(restaurantRatingRepositoryProvider('id 값'));

  final notifier = RestaurantRatingStateNotifier(repository: repository);

  return notifier;
});

class RestaurantRatingStateNotifier
    extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading());
}
