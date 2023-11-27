import 'package:code_factory_middle/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    // 요청을 보낼 때의 header, 마지막 return 에서 요청이 보내진다.
    if (options.headers["accessToken"] == "true") {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    if (options.headers["refreshToken"] == "true") {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 어떤 요청에서 에러가 발생 했는지 인지할 수 있도록 표시
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      // refreshToken이 없으면 재발급이고 뭐고 없다. 받은 에러를 그대로 반환한다.
      handler.reject(err);
      return;
      // return handler.reject(err); // 이것도 가능, reject는 void 반환형이다.
    }

    // 응답 상태코드가 401 에러인가?
    final isStatus401 = err.response?.statusCode == 401;
    // refresh token 을 재발급 받을때 발생한 에러인가?
    final isPathRefresh = err.requestOptions.path == '/auth/token';
    // 둘다 true 이면 refresh token에 문제가 있으므로 새로 요청을 보내도 에러가 발생한다.

    // 해당 에러가 refresh 재발급 요청이 아니라면.
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // requestOptions 의 토큰을 변경한다.
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        // 이후 작업에도 사용 가능하도록 storage access token 을 수정한다.
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 실제 요청을 보낼때 필요한 모든 값은 requestOptions 에 존재한다.
        // 원래 요청을 토큰만 변경해서 다시 보낸다.
        final response = await dio.fetch(options);

        return handler.resolve(response);
      } on DioError catch (e) {
        // 여기서 에러가 발생하면 어떠한 상황이라도 더 이상 refresh 할 수 없다.
        return handler.reject(e);
      }
    }

    return super.onError(err, handler);
  }
}
