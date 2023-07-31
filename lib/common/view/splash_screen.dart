// 기본 페이지가 될 예정
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/common/const/data.dart';
import 'package:flutter_study/common/layout/default_layout.dart';
import 'package:flutter_study/common/view/root_tab.dart';
import 'package:flutter_study/user/view/login_screen.dart';

import '../const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  // await 할 수 없다. initstate는
  void initState() {
    // TODO: implement initState
    super.initState();

    // deleteToken();
    checkToken();
  }

  void deleteToken() async{
    await storage.deleteAll();
  }

  void checkToken() async{
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    // print(refreshToken);
    // print(accessToken);

    final dio =Dio();

    try{
      final resp = await dio.post('http://$ip/auth/token',
        options: Options(
            headers: {
              'authorization' : 'Bearer $refreshToken',
            }
        ),
      );
      
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );
      // print(resp.data);
    }catch(e){
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
              (route) =>false,
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: BODY_TEXT_COLOR,
      child: SizedBox(
        // 너비를 최대한으로 하면 자동으로 좌우로 가운데 정렬이 된다.
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo3.png',
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 16.0),
            // 로딩 돌아가는 동그라미
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
