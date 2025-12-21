import 'package:flutter/material.dart';
import 'package:grocery/core/constants/apiClients.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EazySupplies',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: AppRoutes.onboarding,
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'core/routes/app_routes.dart';
// import 'core/routes/on_generate_route.dart';
// import 'core/themes/app_themes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Clear SharedPreferences at app start
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear();

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   // Optional: Attempt to clear on app close
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.detached) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       debugPrint("SharedPreferences cleared on app close");
//     }
//   }

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



