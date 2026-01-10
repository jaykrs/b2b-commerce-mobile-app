import 'package:EazySupplies/core/enums/login_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/themes/app_themes.dart';
import '../../../core/utils/validators.dart';
import 'login_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPageForm extends StatefulWidget {
  final LoginType loginType;
  const LoginPageForm({super.key, required this.loginType});

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

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

    final url = Uri.parse(ApiConfig.login);

    try {
      setState(() => loading = true);
      Map<String, dynamic> payload = {
        'password': passwordCtrl.text.trim(),
      };

      switch (widget.loginType) {
        case LoginType.email:
          payload['email'] = emailCtrl.text.trim();
          break;

        case LoginType.phone:
          payload['phone'] = emailCtrl.text.trim();
          break;

        case LoginType.gst:
          payload['gstn'] = emailCtrl.text.trim();
          break;
      }
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: payload,
      );

      setState(() => loading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged in successfully!")),
        );
        Navigator.pushNamed(context, AppRoutes.entryPoint);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${response.data}")),
        );
      }
    } on DioException catch (e) {
      setState(() => loading = false);

      debugPrint('Dio error type: ${e.type}');
      debugPrint('Dio message: ${e.message}');
      debugPrint('Dio response: ${e.response}');
      debugPrint('Request path: ${e.requestOptions.path}');

      final String errorMsg = _dioErrorMessage(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }

    // } on DioException catch (e) {
    //   setState(() => loading = false);

    //   // DioException contains requestOptions, response, type, message
    //   print(e.response);
    //   String errorMsg = e.response != null
    //       ? "Login failed: ${e.response?.data}"
    //       : "Connection error: ${e.message}";

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(errorMsg)),
    //   );
    // }
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
              if (widget.loginType == LoginType.email) ...[
                const Text("Email"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email.call,
                  textInputAction: TextInputAction.next,
                ),
              ] else if (widget.loginType == LoginType.phone) ...[
                const Text("Phone"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType:
                      TextInputType.text, // allow text input for phone
                  validator: Validators.phone,
                  textInputAction: TextInputAction.next,
                ),
              ] else ...[
                const Text("GST"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.text,
                  // validator: Validators.gst.call,
                  textInputAction: TextInputAction.next,
                )
              ],
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
              // LoginButton(
              //   onPressed: loading ? null : onLogin,
              //   loading: loading
              //       ? const CircularProgressIndicator(color: Colors.white)
              //       : const Text("Login"),
              // ),

              LoginButton(
                onPressed: onLogin,
                loading: loading,
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _dioErrorMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please try again.';
    case DioExceptionType.sendTimeout:
      return 'Request timeout. Please try again.';
    case DioExceptionType.receiveTimeout:
      return 'Server response timeout.';
    case DioExceptionType.badCertificate:
      return 'Invalid SSL certificate.';
    case DioExceptionType.connectionError:
      return 'No internet connection or server unreachable.';
    case DioExceptionType.badResponse:
      return 'Login failed: ${e.response?.data}';
    case DioExceptionType.cancel:
      return 'Request cancelled.';
    case DioExceptionType.unknown:
    default:
      return 'Unable to connect to server. Please try again.';
  }
}
