import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.loading,
    this.text = "Login",
  });

  final VoidCallback? onPressed;
  final bool loading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                height: Responsive.hp(context, 22 / 8),
                width: Responsive.wp(context, 22 / 4),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}
