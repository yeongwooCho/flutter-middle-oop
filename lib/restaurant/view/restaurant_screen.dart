import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/restaurant/component/restaurant_card.dart';
import 'package:code_factory_middle/restaurant/provider/restaurant_provider.dart';
import 'package:code_factory_middle/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // TODO: 테스트 용도이다. 다른 상태에 대한 처리가 되어있지 않다.
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: cp.data.length, // 어차피 데이터 없으면 위에서 걸린다.
        itemBuilder: (context, index) {
          final pItem = cp.data[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: pItem.id,
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, value) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
