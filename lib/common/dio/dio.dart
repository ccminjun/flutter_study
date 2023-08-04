import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_study/common/const/data.dart';

class CustomInterceptor extends Interceptor{
  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 header에 accesstoken : true값이 있다면
  // 실제 토큰 가져와서 token 변경
  final FlutterSecureStorage storage;

  // 스토리지에서 가져오기 위해
  CustomInterceptor({
    required this.storage,
  });

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    print('[REQ] [${options.method}] ${options.uri}');

    return super.onRequest(options, handler);
  }
  // 2) 응답을 받을때
  // 3) 에러가 났을때
}