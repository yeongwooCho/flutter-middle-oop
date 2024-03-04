import 'package:code_factory_middle/product/model/product_model.dart';
import 'package:code_factory_middle/user/model/basket_item_model.dart';
import 'package:code_factory_middle/user/model/patch_basket_body.dart';
import 'package:code_factory_middle/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketStateNotifier, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketStateNotifier(repository: repository);
});

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketStateNotifier({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map((e) => PatchBasketBodyBasket(
                  productId: e.product.id,
                  count: e.count,
                ))
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) 아직 장바구니에 해당되는 상품이 없으면 장바구니에 상품을 추가한다.
    // 2) 상품이 들어 있으면 장바구니에 있는 값에 +1 을 한다. ? count 수량 아니었음?

    // null 이 아니면 존재한다.
    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }

    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
  }) async {
    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (!exists) {
      // 상품이 존재하지 않으면 즉시 함수를 반환하고 아무것도 하지 않는다.
      return;
    } else {
      final existingProduct = state.firstWhere(
        (element) => element.product.id == product.id,
      ); // 에러 안남

      if (existingProduct.count == 1 || isDelete) {
        state =
            state.where((element) => element.product.id != product.id).toList();
      } else {
        state = state
            .map((e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
            .toList();
      }
    }

    await patchBasket();
  }
}
