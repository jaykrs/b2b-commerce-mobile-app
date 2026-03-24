import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'dart:io';
import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  HttpOverrides.global = MyHttpOverrides();
  final bool isLoggedIn = await _checkAuth();

  runApp(
    MyApp(
      initialRoute: isLoggedIn ? AppRoutes.entryPoint : AppRoutes.onboarding,
    ),
  );
}

/// 🔐 Cookie-based auth check
Future<bool> _checkAuth() async {
  try {
    final cookies = await ApiClient.cookieJar.loadForRequest(
      Uri.parse(ApiConfig.baseUrl),
    );

    final now = DateTime.now();

    return cookies.any((c) {
      if (c.name != 'authToken') return false;
      if (c.value.isEmpty) return false;

      // Session cookie (no expiry) → valid
      if (c.expires == null) return true;

      // Persistent cookie → check expiry
      return c.expires!.isAfter(now);
    });
  } catch (e) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EazySupplies',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: initialRoute,
    );
  }
}
