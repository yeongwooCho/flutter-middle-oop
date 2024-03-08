import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/provider/pagination_provider.dart';
import 'package:code_factory_middle/order/model/order_model.dart';
import 'package:code_factory_middle/order/model/post_order_body.dart';
import 'package:code_factory_middle/order/repository/order_repository.dart';
import 'package:code_factory_middle/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(
    ref: ref,
    repository: repository,
  );
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();
      final id = uuid.v4();

      final state = ref.read(basketProvider);

      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) => PostOrderBodyProduct(
                    productId: e.product.id,
                    count: e.count,
                  ))
              .toList(),
          totalPrice: state.fold(
            0,
            (pre, ne) => pre + (ne.product.price * ne.count),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
