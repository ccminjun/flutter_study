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
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    // 401에러가 났을때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토근이 재발급되면
    // 다시새로운 토큰으로 요청을 한다.
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다.
    if(refreshToken ==null){
      // 에러를 던질때는 handler.reject를 사용한다.
     return handler.reject(err);
    }

    // 응답이 없을수도 있으니 response?
    // 401에러가 나면 isStatus401가 true로 반환받음
    final isStatus401 = err.response?.statusCode == 401;
    // 요청의 path가 토큰이면 즉 토큰을 발급받으려던 요청이 아니었다면,
    final isPathRefresh = err.requestOptions.path == 'auth/token';

    if(isStatus401 && !isPathRefresh){
      final dio = Dio();

      try{
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        // 에러의 request options 에 새로 넣어줌
        final options = err.requestOptions;

        // 토큰 받아오기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        // 토큰을 넣어줘야됨, 나중에 또 요청을 가져올 때 넣어주지 않으면 예전 값 그대로 가져오기때문
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 토큰만 바꿔서 요청 재전송 토큰만 문제였으면 response 옴
        final response = await dio.fetch(options);

        // 성공적인 요청에 대한 값을 반환할 수 있음. UI에서는 오류가 안나는것처럼 보임
        return handler.resolve(response);

        // DioError 테니까
      }on DioError catch(e){
        // 그대로 에러를 반환
        return handler.reject(e);
      }
    }
    // 에러난것에 response 해줌
    return handler.reject(err);
  }
}