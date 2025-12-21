import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:grocery/core/constants/api_config.dart';
import 'package:path_provider/path_provider.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      // VERY IMPORTANT
      receiveDataWhenStatusError: true,
    ),
  );

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'),
    );

    dio.interceptors.add(CookieManager(cookieJar));
  }
}
