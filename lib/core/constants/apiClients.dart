import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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

    // 🔴 SSL BYPASS (DEV ONLY)
    (dio.httpClientAdapter as IOHttpClientAdapter)
        .onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.interceptors.add(CookieManager(cookieJar));
  }
}


// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:EazySupplies/core/constants/api_config.dart';
// import 'package:path_provider/path_provider.dart';

// class ApiClient {
//   static late final Dio dio;
//   static late PersistCookieJar cookieJar;

//   static Future<void> init() async {
//     final dir = await getApplicationDocumentsDirectory();

//     cookieJar = PersistCookieJar(storage: FileStorage('${dir.path}/cookies'));

//     dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConfig.baseUrl, // Make sure this is https://api.eazysupplies.com/api
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {'Content-Type': 'application/json'},
//       ),
//     );

//     dio.interceptors.add(CookieManager(cookieJar));
//   }
// }



// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:EazySupplies/core/constants/api_config.dart';
// import 'package:path_provider/path_provider.dart';

// class ApiClient {
//   static final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: ApiConfig.baseUrl,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       receiveDataWhenStatusError: true,
//       connectTimeout: ApiConfig.timeout,
//       receiveTimeout: ApiConfig.timeout,
//     ),
//   );

//   static late PersistCookieJar cookieJar;

//   static Future<void> init() async {
//     final dir = await getApplicationDocumentsDirectory();

//     cookieJar = PersistCookieJar(
//       storage: FileStorage('${dir.path}/cookies'),
//     );

//     dio.interceptors.add(CookieManager(cookieJar));
//   }
// }


// // class ApiClient {
// //   static final Dio dio = Dio(
// //     BaseOptions(
// //       baseUrl: ApiConfig.baseUrl,
// //       headers: {
// //         'Content-Type': 'application/json',
// //       },
// //       receiveDataWhenStatusError: true,
// //     ),
// //   );

// //   static late PersistCookieJar cookieJar;

// //   static Future<void> init() async {
// //     final dir = await getApplicationDocumentsDirectory();

// //     cookieJar = PersistCookieJar(
// //       storage: FileStorage('${dir.path}/cookies'),
// //     );

// //     dio.interceptors.add(CookieManager(cookieJar));
// //   }
// // }

