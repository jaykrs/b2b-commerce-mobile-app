import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();

  final bool isLoggedIn = await _checkAuth();

  runApp(
    MyApp(
      initialRoute:
          isLoggedIn ? AppRoutes.entryPoint : AppRoutes.onboarding,
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



// import 'package:flutter/material.dart';
// import 'package:EazySupplies/core/constants/apiClients.dart';
// import 'core/constants/apiCall.dart';
// import 'core/routes/app_routes.dart';
// import 'core/routes/on_generate_route.dart';
// import 'core/themes/app_themes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await ApiClient.init();

//   final bool isLoggedIn = await _checkAuth();


//   runApp(MyApp(
//     initialRoute:
//         isLoggedIn ? AppRoutes.entryPoint : AppRoutes.onboarding,
//   ));
// }

// class MyApp extends StatelessWidget {
//   final String initialRoute;

//   const MyApp({
//     super.key,
//     required this.initialRoute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EazySupplies',
//       theme: AppTheme.defaultTheme,
//       onGenerateRoute: RouteGenerator.onGenerate,
//       initialRoute: initialRoute,
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:EazySupplies/core/constants/apiClients.dart';

// import 'core/routes/app_routes.dart';
// import 'core/routes/on_generate_route.dart';
// import 'core/themes/app_themes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await ApiClient.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'EazySupplies',
//       theme: AppTheme.defaultTheme,
//       onGenerateRoute: RouteGenerator.onGenerate,
//       initialRoute: AppRoutes.onboarding,
//     );
//   }
// }



// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import 'core/routes/app_routes.dart';
// // import 'core/routes/on_generate_route.dart';
// // import 'core/themes/app_themes.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   // Clear SharedPreferences at app start
// //   final prefs = await SharedPreferences.getInstance();
// //   await prefs.clear();

// //   runApp(const MyApp());
// // }

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     super.dispose();
// //   }

// //   // Optional: Attempt to clear on app close
// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) async {
// //     if (state == AppLifecycleState.detached) {
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.clear();
// //       debugPrint("SharedPreferences cleared on app close");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'EazySupplies',
// //       theme: AppTheme.defaultTheme,
// //       onGenerateRoute: RouteGenerator.onGenerate,
// //       initialRoute: AppRoutes.onboarding,
// //     );
// //   }
// // }



