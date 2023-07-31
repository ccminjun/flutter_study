import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_study/common/component/custom_text_form_field.dart';
import 'package:flutter_study/common/const/colors.dart';
import 'package:flutter_study/common/const/data.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';


  @override
  Widget build(BuildContext context) {

    final dio = Dio();

    // final ip2 = simulatorIp;


    // final ip = '172.30.1.55';
    // final ip = '172.30.1.254';

    return DefaultLayout(
      child: SingleChildScrollView( // 키보드를 눌러도 안짤리게 해줌
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 키보드 휠 누를때 내려감
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _Title(),
                const SizedBox(height: 16.0,),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width /3 * 2,
                  // height: MediaQuery.of(context).size.width /1,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                   username = value;
                  },
                ),
                const SizedBox(height: 16.0,),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0,),
                ElevatedButton(
                  onPressed: () async{
                    // ID:비밀번호
                    final rawString = '$username:$password';

                    // print(rawString);

                    // 인코딩 하는 것  Codec에 어떻게 인코딩 할 건지 정의한것
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    // 원하는 rawString 을 token으로 전환
                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post('http://$ip/auth/login',
                        options: Options(
                          headers: {
                            'authorization' : 'Basic $token',
                          }
                        ),
                    );

                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    // 스토리지에 넣기
                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> RootTab(),
                      ),
                    );
                    // ignore: avoid_print
                    // print(resp.data);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async{

                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      )
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요\n 오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
