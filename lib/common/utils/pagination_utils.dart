import 'package:code_factory_middle/common/provider/pagination_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
