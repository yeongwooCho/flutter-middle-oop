import 'package:flutter/material.dart';

void main() {
  runApp(_App());
}

// primary로 관리하기
// 나중에 route를 사용하기 할때 context를 사용해야 하기에 아래와 같이 관리한다.
class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
