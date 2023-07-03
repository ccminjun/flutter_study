import 'package:flutter/material.dart';

void main() {
  runApp(
      _App()
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 오른쪽 디버그 사라지게 해준다.
      home: Scaffold(
        body: Container(),
      )

    );
  }
}

