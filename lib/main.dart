import 'package:flutter/material.dart';
import 'package:flutter_study/common/component/custom_text_form_field.dart';

void main() {
  runApp(
      _App()
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,  // 오른쪽 디버그 사라지게 해준다.
      home: Scaffold(
        backgroundColor: Colors.white, // 넣어줘야 회색이 보임
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              onChanged: (String value) { },
            ),
            CustomTextFormField(
              hintText: '비밀번호를 입력해주세요.',
              onChanged: (String value) { },
              obscureText: true,
            ),
          ],
        ),
      )

    );
  }
}

