import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_themes.dart';
import '../../../core/utils/validators.dart';
import 'login_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({
    super.key,
  });

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

// class _LoginPageFormState extends State<LoginPageForm> {
//   final _key = GlobalKey<FormState>();
  
//   bool isPasswordShown = false;
//   onPassShowClicked() {
//     isPasswordShown = !isPasswordShown;
//     setState(() {});
//   }

//   onLogin() {
//     final bool isFormOkay = _key.currentState?.validate() ?? false;
//     if (isFormOkay) {
//       // Navigator.pushNamed(context, AppRoutes.entryPoint);

//       try {
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "name": nameCtrl.text,
//         "email": emailCtrl.text,
//         "phone": phoneCtrl.text,
//         "password": passwordCtrl.text,
//         "gstn": gstCtrl.text
//       }),
//     );

//     setState(() => loading = false);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Your account registered successfully!")),
//       );
//        Navigator.pushNamed(context, AppRoutes.login);
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
//     }
//   } catch (e) {
//     setState(() => loading = false);
//     print("Error: $e");
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Failed: $e")));
//   }
//     }
//   }

class _LoginPageFormState extends State<LoginPageForm> {
  final _key = GlobalKey<FormState>();

  bool isPasswordShown = false;
  bool loading = false;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void onPassShowClicked() {
    setState(() => isPasswordShown = !isPasswordShown);
  }

  Future<void> onLogin() async {
    final bool isFormOkay = _key.currentState?.validate() ?? false;
    if (!isFormOkay) return;

    setState(() => loading = true);

    final url = Uri.parse("http://api.eazysupplies.com/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailCtrl.text.trim(),
          "password": passwordCtrl.text.trim(),
        }),
      );

      setState(() => loading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged in successfully!")),
        );
        Navigator.pushNamed(context, AppRoutes.entryPoint);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login failed: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email Field
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email.call,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppDefaults.padding),

              // Password Field
              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordCtrl,
                validator: Validators.password.call,
                onFieldSubmitted: (_) => onLogin(),
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordShown,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: onPassShowClicked,
                    icon: SvgPicture.asset(AppIcons.eye, width: 24),
                  ),
                ),
              ),

              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text('Forget Password?'),
                ),
              ),

              // Login Button
              LoginButton(
                onPressed: loading ? null : onLogin,
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class _LoginPageFormState extends State<LoginPageForm> {
//   final _key = GlobalKey<FormState>();

//   bool isPasswordShown = false;
//   bool loading = false;

//   final emailCtrl = TextEditingController();
//   final passwordCtrl = TextEditingController();

//   onPassShowClicked() {
//     setState(() => isPasswordShown = !isPasswordShown);
//   }

//   Future<void> onLogin() async {
//     final bool isFormOkay = _key.currentState?.validate() ?? false;

//     if (!isFormOkay) return;

//     setState(() => loading = true);

//     final url = Uri.parse("http://api.eazysupplies.com/api/auth/login"); 
//     // Use your LAN IP here

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "email": emailCtrl.text.trim(),
//           "password": passwordCtrl.text.trim(),
//         }),
//       );

//       setState(() => loading = false);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Your account logged in successfully!")),
//         );
//         Navigator.pushNamed(context, AppRoutes.entryPoint);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Server Error: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       setState(() => loading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to connect: $e")),
//       );
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: AppTheme.defaultTheme.copyWith(
//         inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(AppDefaults.padding),
//         child: Form(
//           key: _key,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Phone Field
//               const Text("Email"),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: emailCtrl,
//                 keyboardType: TextInputType.number,
//                 validator: Validators.email.call,
//                 textInputAction: TextInputAction.next,
//               ),
//               const SizedBox(height: AppDefaults.padding),

//               // Password Field
//               const Text("Password"),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: passwordCtrl,
//                 validator: Validators.password.call,
//                 onFieldSubmitted: (v) => onLogin(),
//                 textInputAction: TextInputAction.done,
//                 obscureText: !isPasswordShown,
//                 decoration: InputDecoration(
//                   suffixIcon: Material(
//                     color: Colors.transparent,
//                     child: IconButton(
//                       onPressed: onPassShowClicked,
//                       icon: SvgPicture.asset(
//                         AppIcons.eye,
//                         width: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // Forget Password labelLarge
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.forgotPassword);
//                   },
//                   child: const Text('Forget Password?'),
//                 ),
//               ),

//               // Login labelLarge
//               LoginButton(onPressed: onLogin),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
