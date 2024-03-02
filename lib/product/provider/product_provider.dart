import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/provider/pagination_provider.dart';
import 'package:code_factory_middle/product/model/product_model.dart';
import 'package:code_factory_middle/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  final notifier = ProductStateNotifier(repository: repository);

  return notifier;
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
