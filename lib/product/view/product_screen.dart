import 'package:code_factory_middle/common/component/pagination_list_view.dart';
import 'package:code_factory_middle/product/component/product_card.dart';
import 'package:code_factory_middle/product/model/product_model.dart';
import 'package:code_factory_middle/product/provider/product_provider.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(context, index, model) {
        return ProductCard.fromProductModel(model: model);
      },
    );
  }
}
