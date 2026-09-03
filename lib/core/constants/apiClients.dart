import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:EazySupplies/core/constants/api_config.dart';

class ApiClient {
  static late final Dio dio;
  static late PersistCookieJar cookieJar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    cookieJar = PersistCookieJar(
      storage: FileStorage('${dir.path}/cookies'),
    );

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(CookieManager(cookieJar));
  }
}
