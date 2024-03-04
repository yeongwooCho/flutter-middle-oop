import 'package:code_factory_middle/common/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [],
      child: _App(),
    ),
  );
}

// primary로 관리하기
// 나중에 route를 사용하기 할때 context를 사용해야 하기에 아래와 같이 관리한다.
class _App extends ConsumerWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      routerConfig: router,
    );
  }
}
