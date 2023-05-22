import 'package:code_factory_middle/common/component/custom_text_form_field.dart';
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력해주세요',
              autofocus: false,
              onChanged: (String value) {},
            ),
            CustomTextFormField(
              hintText: '비밀번호를 입력해주세요',
              autofocus: false,
              obscureText: true,
              onChanged: (String value) {},
            ),
          ],
        ),
      ),
    );
  }
}
