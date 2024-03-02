import 'package:code_factory_middle/common/model/cursor_pagination_model.dart';
import 'package:code_factory_middle/common/model/model_with_id.dart';
import 'package:code_factory_middle/common/provider/pagination_provider.dart';
import 'package:code_factory_middle/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
  BuildContext context,
  int index,
  T model, // 현재 index 에 해당되는 모델 값
);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeListener(scrollListener);
    controller.dispose();
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 로딩
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: const Text('다시 시도'),
          ),
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1, // 어차피 데이터 없으면 위에서 걸린다.
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            // 마지막 아이템 1개는 로딩 뷰를 집어넣는다.
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터 입니다.ㅠㅠ'),
              ),
            );
          }

          final pItem = cp.data[index];

          return widget.itemBuilder(context, index, pItem);
        },
        separatorBuilder: (_, value) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
