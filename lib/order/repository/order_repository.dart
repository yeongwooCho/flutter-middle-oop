import 'package:code_factory_middle/order/model/order_model.dart';
import 'package:code_factory_middle/order/model/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

@RestApi()
abstract class OrderRepository {
  // baseUrl = http://$ip/order
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
