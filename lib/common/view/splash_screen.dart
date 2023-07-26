// 기본 페이지가 될 예정
import 'package:flutter/material.dart';
import 'package:flutter_study/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Column(children: [],),);
  }
}
