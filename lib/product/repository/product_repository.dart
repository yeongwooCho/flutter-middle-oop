import 'package:code_factory_middle/common/const/data.dart';
import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/model/pagination_params.dart';
import 'package:code_factory_middle/common/repository/dio/dio.dart';
import 'package:code_factory_middle/common/repository/pagination/base_pagination_repository.dart';
import 'package:code_factory_middle/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    final repository = ProductRepository(
      dio,
      baseUrl: 'http://$ip/product',
    );

    return repository;
  },
);

@RestApi()
abstract class ProductRepository
    implements IBasePaginationRepository<ProductModel> {
  // baseUrl = http://$ip/product
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  // http://$ip/product
  @GET('/')
  @Headers({
    'accessToken': "true",
  })
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/product/:id
  @GET('/{id}')
  @Headers({
    "accessToken": "true",
  })
  Future<ProductModel> getProductDetail({
    @Path() required String id,
  });
}
