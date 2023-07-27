import 'package:flutter/material.dart';
import 'package:flutter_study/common/component/custom_text_form_field.dart';
import 'package:flutter_study/common/view/splash_screen.dart';
import 'package:flutter_study/user/view/login_screen.dart';

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
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,  // 오른쪽 디버그 사라지게 해준다.
      home: SplashScreen(),
    );
  }
}

