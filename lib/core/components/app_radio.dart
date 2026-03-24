import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: isActive ? AppColors.primary : AppColors.placeholder),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: Responsive.wp(context, 16 / 4),
        height: Responsive.hp(context, 16 / 8),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.textInputBackground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
