import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../../../core/utils/validators.dart';
import 'already_have_accout.dart';
import 'sign_up_button.dart';
import '../../../core/constants/app.config.dart';
import '../../../core/routes/app_routes.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final gstCtrl = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    gstCtrl.dispose();
    super.dispose();
  }
Future<void> registerUser() async {
  if (!_formKey.currentState!.validate()) return;

  if (passwordCtrl.text != confirmPasswordCtrl.text) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")));
    return;
  }

  setState(() => loading = true);
  print("Sending request...");

  final url =
      Uri.parse('http://api.eazysupplies.com/api/auth/user'); // correct HTTPS
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nameCtrl.text,
        "email": emailCtrl.text,
        "phone": phoneCtrl.text,
        "password": passwordCtrl.text,
        "gstn": gstCtrl.text
      }),
    );

    setState(() => loading = false);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your account registered successfully!")),
      );
       Navigator.pushNamed(context, AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
    }
  } catch (e) {
    setState(() => loading = false);
    print("Error: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed: $e")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(AppDefaults.margin),
        padding: const EdgeInsets.all(AppDefaults.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppDefaults.boxShadow,
          borderRadius: AppDefaults.borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            const SizedBox(height: 8),
            TextFormField(
              controller: nameCtrl,
              validator: Validators.requiredWithFieldName('Name').call,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppDefaults.padding),
            const Text("Email"),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailCtrl,
              validator:Validators.email.call,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppDefaults.padding),
            const Text("GST No"),
            const SizedBox(height: 8),
            TextFormField(
              controller: gstCtrl,
              validator:Validators.requiredWithFieldName('GstNo').call,
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppDefaults.padding),
            const Text("Phone Number"),
            const SizedBox(height: 8),
            TextFormField(
              controller: phoneCtrl,
              validator: Validators.required.call,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: AppDefaults.padding),
            const Text("Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordCtrl,
              validator: Validators.password.call,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(AppIcons.eye, width: 24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDefaults.padding),
            const Text("Confirm Password"),
            const SizedBox(height: 8),
            TextFormField(
              controller: confirmPasswordCtrl,
              validator: Validators.required.call,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(AppIcons.eye, width: 24),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDefaults.padding),

            // 🔥 Keep your button, but connect API
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: registerUser,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
            ),

            const AlreadyHaveAnAccount(),
            const SizedBox(height: AppDefaults.padding),
          ],
        ),
      ),
    );
  }
}
