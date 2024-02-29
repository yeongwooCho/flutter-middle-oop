import 'package:code_factory_middle/common/const/data.dart';
import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/model/pagination_params.dart';
import 'package:code_factory_middle/common/repository/dio/dio.dart';
import 'package:code_factory_middle/common/repository/pagination/base_pagination_repository.dart';
import 'package:code_factory_middle/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, rid) {
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRatingRepository(
    dio,
    baseUrl: 'http://$ip/restaurant/$rid/rating',
  );

  return repository;
});

@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  // baseUrl = http://$ip/restaurant/:rid/rating
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    "accessToken": "true",
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
